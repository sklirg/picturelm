use serde::Deserialize;
use stylist::css;
use yew::prelude::*;
use yew::{function_component, Properties};
use yew_router::prelude::*;

use crate::gallery::image::{ImageThumbnailView, Model as Image};
use crate::Route;

#[derive(Clone, Deserialize, Eq, Properties, PartialEq)]
pub struct Gallery {
    pub title: String,
    pub images: Option<Vec<Image>>,
}

#[function_component(GalleryView)]
pub fn gallery_view(gallery: &Gallery) -> Html {
    let images = match &gallery.images {
        Some(images) => {
            let mut imgs = vec!();
            for image in images {
                imgs.push(
                html! {
                    <li>{image.to_owned().title}</li>
                });
            }
            html!{<><p>{"imgs"}</p>{imgs}</>}
        }
        None => html! {"no imgs"},
    };
    html! {
        <>
            <h2>
                <Link<Route> to={Route::Home}>
                    {gallery.title.to_owned()}
                </Link<Route>>
            </h2>
            <ul>
                {images}
            </ul>
        </>
    }
}

pub struct Model {}

pub enum Msg {
    LoadGalleries,
}

impl Component for Gallery {
    type Message = Msg;
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Self {
            title: "foo".to_owned(),
            images: None,
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        false
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        let link = ctx.link();

        let mut images: Vec<Image> = vec![];
        if let Some(_images) = &self.images {
            images = _images.to_vec();
        }

        html! {
            <div class={css!("background-color: green;")}>
                <button onclick={link.callback(|_| Msg::LoadGalleries)}>{ "-1" }</button>
                <p>{ self.title.to_owned() }</p>
                {for images.iter().map(|i| html!{<ImageThumbnailView title={i.title.to_owned()} />})}
            </div>
        }
    }
}
