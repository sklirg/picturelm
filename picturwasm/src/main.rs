mod gallery;

use gloo_net::http::Request;
use serde::Deserialize;
use stylist::css;
use yew::prelude::*;
use yew::Properties;
use yew_router::prelude::*;

use crate::gallery::gallery::{Gallery, GalleryView};
use crate::gallery::image::{ImageView, Model as Image};

#[derive(Clone, Routable, PartialEq)]
enum Route {
    #[at("/")]
    Home,
    #[at("/gallery/:gallery")]
    Gallery { gallery: String },
    #[at("/gallery/:gallery/:image")]
    Image { gallery: String, image: String },
}

enum Msg<T> {
    LoadGalleries,
    SetGalleries(FetchState<T>),
}

#[derive(PartialEq)]
enum FetchState<T> {
    NotStarted,
    InProgress,
    Success(T),
    Error(String),
}

struct Model {
    _route_listener: Option<yew_router::scope_ext::HistoryHandle>,
}
struct App {
    galleries: FetchState<Vec<Gallery>>,
}
struct Home {}

impl Component for Model {
    type Message = ();
    type Properties = ();

    fn create(ctx: &Context<Self>) -> Self {
        log::info!("foo");
        let listener =
            ctx.link()
                .add_history_listener(ctx.link().callback(move |history: AnyHistory| {
                    //let loc = ctx.link().location();
                    //ctx.link().history().unwrap().push(Route::Home);
                    //panic!("history{}", history.location().pathname());
                    log::info!("history callback testin");
                }));

        Self {
            _route_listener: listener,
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        false
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
            <div class={css!("display: grid; grid-template-rows: 5rem auto 5rem; min-height: 100vh;")}>
                <header class={css!("background-color: #3c3c3c; color: #ffffff;")}>
                    <h1>
                        <Link<Route> to={Route::Home}>
                            {"Picturwasm"}
                        </Link<Route>>
                    </h1>
                </header>
                <main>
                    <BrowserRouter>
                        <Switch<Route> render={Switch::render(switch)} />
                    </BrowserRouter>
                </main>
                <footer class={css!("background-color: #3c3c3c; color: #cccccc;")}>
                    {"Stuff"}
                </footer>
            </div>
        }
    }
}

#[derive(PartialEq, Properties)]
pub struct HomeProps {
    pub galleries: Vec<Gallery>,
}

impl Component for Home {
    type Message = ();
    type Properties = HomeProps;

    fn create(_ctx: &Context<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        false
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div>
            {for ctx.props().galleries.iter().map(|g| html! {
                    <li>
                        <Link<Route> to={Route::Gallery {gallery: {g.title.to_owned()}}}>
                            {g.title.to_owned()}
                        </Link<Route>>
                    </li>
                })}
            </div>
        }
    }
}

impl Component for App {
    type Message = Msg<Vec<Gallery>>;
    type Properties = ();

    fn create(ctx: &Context<Self>) -> Self {
        ctx.link().send_message(Msg::LoadGalleries);

        Self {
            galleries: FetchState::NotStarted,
        }
    }

    fn update(&mut self, ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::SetGalleries(galleries) => {
                self.galleries = galleries;

                // trigger re-render
                true
            }
            Msg::LoadGalleries => {
                ctx.link()
                    .send_message(Msg::SetGalleries(FetchState::InProgress));
                ctx.link().send_future(async {
                    match fetch_all_galleries().await {
                        Ok(galleries) => Msg::SetGalleries(FetchState::Success(galleries)),
                        Err(err) => Msg::SetGalleries(FetchState::Error(format!(
                            "Failed to fetch galleries ({})",
                            err
                        ))),
                    }
                });

                // don't trigger a re-render
                false
            }
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let link = ctx.link();

        let gallery_view = match &self.galleries {
            FetchState::Success(galleries) => html! {
                <div>
                    <Home galleries={galleries.to_owned()} />
                </div>
            },
            FetchState::NotStarted => html! {
                <div>
                    <button onclick={link.callback(|_| Msg::LoadGalleries)}>{ "+1" }</button>
                </div>
            },
            FetchState::Error(msg) => html! {
                <div>
                    <p>{"Failed to load galleries: "}{msg}</p>
                </div>
            },
            FetchState::InProgress => html! {
                <div>
                    <p>{"Loading galleries..."}</p>
                </div>
            },
        };

        html! {
            gallery_view
        }
    }
}

fn switch(routes: &Route) -> Html {
    match routes {
        Route::Home => html! { <App /> },
        Route::Gallery { gallery } => html! { <GalleryView title={gallery.to_owned()} /> },
        Route::Image {
            gallery: _gallery,
            image,
        } => html! { <ImageView title={image.to_owned()} /> },
    }
}

#[derive(Deserialize)]
struct GalleryAPIResponse {
    data: APIResponseAllGalleries,
}
#[derive(Deserialize)]
struct APIResponseAllGalleries {
    #[serde(rename = "allGalleries")]
    all_galleries: APIResponseAllGalleriesEdges,
}
#[derive(Deserialize)]
struct APIResponseAllGalleriesEdges {
    edges: Vec<APIResponseAllGalleriesNode>,
}
#[derive(Deserialize)]
struct APIResponseAllGalleriesNode {
    node: Gallery,
}

async fn fetch_all_galleries() -> Result<Vec<Gallery>, gloo_net::Error> {
    let url = "https://camerabag.sklirg.io/graphql".to_string();
    let body = r#"{"query": "
query {
  allGalleries {
    edges {
      node {
        imageSet {
          edges {
            node {
              sizes
              exif {
                cameraModel
                exposureProgram
                focalLength
                fStop
                iso
                lensModel
                shutterSpeed
                coordinates
              }
              imageUrl
              title
            }
          }
        }
        description
        thumbnailImage {
          sizes
          exif {
            cameraModel
            exposureProgram
            focalLength
            fStop
            iso
            lensModel
            shutterSpeed
            coordinates
          }
          imageUrl
          title
        }
        slug
        title
        id
      }
    }
  }
}"
    }"#
    .replace('\n', "");

    let req: GalleryAPIResponse = Request::post(&url)
        .body(body)
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .send()
        .await?
        .json()
        .await?;

    let mut galleries: Vec<Gallery> = vec![];

    for gallery in &req.data.all_galleries.edges {
        galleries.push(gallery.node.to_owned());
    }

    Ok(galleries)
}

fn main() {
    wasm_logger::init(wasm_logger::Config::new(log::Level::Trace));
    yew::start_app::<Model>();
}
