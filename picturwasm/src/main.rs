mod gallery;

use serde::Deserialize;
use yew::prelude::*;
use yew_router::prelude::*;

use crate::gallery::gallery::{Gallery, GalleryView};
use crate::gallery::image::{ImageView, Model as Image};

#[derive(Clone, Routable, PartialEq)]
enum Route {
    #[at("/")]
    Home,
    #[at("/gallery/:gallery")]
    Gallery { gallery: String },
    #[at("/gallery/:title/:image")]
    Image { /*gallery: String,*/ image: String, },
}

enum Msg {
    LoadGalleries,
    InsertGalleries(Vec<Gallery>),
}

enum GalleryFetchStatus {
    NotStarted,
    InProgress,
    Success,
    Error,
}

struct Model {}
struct Home {
    galleries: Option<Vec<Gallery>>,
    gallery_fetch_status: GalleryFetchStatus,
}

impl Component for Model {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        false
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
            <BrowserRouter>
                <Switch<Route> render={Switch::render(switch)} />
            </BrowserRouter>
        }
    }
}

impl Component for Home {
    type Message = Msg;
    type Properties = ();

    //     fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
    fn create(_ctx: &Context<Self>) -> Self {
        Self {
            galleries: None,
            gallery_fetch_status: GalleryFetchStatus::NotStarted,
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::InsertGalleries(galleries) => {
                self.galleries = Some(galleries);

                // trigger re-render
                true
            }
            Msg::LoadGalleries => {
                //wasm_bindgen_futures::spawn_local(async move {
                //wasm_bindgen_futures::spawn_local(async {
                _ctx.link().send_future(async {
                    match fetch_all_galleries().await {
                        //Ok(galleries) => _ctx.link().send_message(Msg::InsertGalleries(galleries)),
                        Ok(galleries) => Msg::InsertGalleries(galleries),
                        Err(err) => panic!("ae"),
                    }

                    //let link = _ctx.link();
                    //link.callback(|_: _| Msg::InsertGalleries(data));

                    //self.update(_ctx, Msg::InsertGalleries(data));

                    
                });

                //self.galleries = Some(data);

                // trigger re-render
                false
            }
        }
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let link = ctx.link();

        html! {
            <div>
                <button onclick={link.callback(|_| Msg::LoadGalleries)}>{ "+1" }</button>
                if let Some(galleries) = &self.galleries {
                    {for galleries.iter().map(|g| html! {
                        <li>
                            <Link<Route> to={Route::Gallery {gallery: {g.title.to_owned()}}}>
                                {g.title.to_owned()}
                            </Link<Route>>
                        </li>
                    })}
                } else {
                    <p>{"No galleries found"}</p>
                }
            </div>
        }
    }
}

fn switch(routes: &Route) -> Html {
    match routes {
        Route::Home => html! { <Home /> },
        Route::Gallery { gallery } => html! { <GalleryView title={gallery.to_owned()} /> },
        Route::Image {
            /*gallery,*/ image,
        } => html! { <ImageView title={image.to_owned()} /> },
    }
}

fn main() {
    yew::start_app::<Model>();
}
use gloo_net::http::Request;
use yew_hooks::prelude::*;
#[function_component(Async)]
fn async_test() -> Html {
    let state = use_async(async move { fetch("galleries".to_string()).await });

    let onclick = {
        let state = state.clone();
        Callback::from(move |_| {
            state.run();
        })
    };

    html! {
        <div>
            <button {onclick} disabled={state.loading}>{"Load it"}</button>
            if state.loading {
                <p>{"loading"}</p>
            } else {
                <div>
                <p>{"foo bar and "}</p>
                if let Some(data) = &state.data {
                    {data}
                }
                </div>
            }
        </div>
    }
}

async fn fetch(url: String) -> Result<String, ()> {
    Ok("yes".to_owned())
}

#[derive(Deserialize)]
struct GalleryAPIResponse {
    data: APIResponseAllGalleries,
}
#[derive(Deserialize)]
struct APIResponseAllGalleries {
    allGalleries: APIResponseAllGalleriesEdges,
}
#[derive(Deserialize)]
struct APIResponseAllGalleriesEdges {
    edges: Vec<APIResponseAllGalleriesNode>,
}
#[derive(Deserialize)]
struct APIResponseAllGalleriesNode {
    node: Gallery,
}

async fn fetch_all_galleries() -> Result<Vec<Gallery>, bool> {
    let url = format!("https://camerabag.sklirg.io/graphql");
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
    .replace("\n", "");

    let req: GalleryAPIResponse = Request::post(&url)
        .body(body)
        .header("Content-Type", "application/json")
        .header("Accept", "application/json")
        .send()
        .await
        .unwrap()
        .json()
        .await
        .unwrap();

    let mut galleries: Vec<Gallery> = vec!();

    for gallery in &req.data.allGalleries.edges {
        galleries.push(gallery.node.to_owned());
    }

    Ok(galleries)
}
