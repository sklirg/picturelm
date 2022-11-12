use serde::Deserialize;
use stylist::css;
use yew::prelude::*;
use yew::{function_component, Properties};

use crate::gallery::image::{Model as Image, ImageThumbnailView};

#[derive(Clone, Deserialize, Properties, PartialEq)]
pub struct Gallery {
    pub title: String,
    pub images: Option<Vec<Image>>,
}

#[function_component(GalleryView)]
pub fn gallery_view(gallery: &Gallery) -> Html {
    html! {
        <div>
            <h2>{gallery.title.to_owned()}</h2>
        </div>
    }
}

pub struct Model {
}

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
