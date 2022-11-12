use serde::Deserialize;
use stylist::css;
use yew::prelude::*;
use yew::{function_component, Properties};

#[function_component(ImageView)]
pub fn image_view(image: &Model) -> Html {
    html! {
        <div>
            <h2>{"imageBIGG"}{image.title.to_owned()}</h2>
        </div>
    }
}

#[function_component(ImageThumbnailView)]
pub fn image_thumbnail_view(image: &Model) -> Html {
    html! {
        <div>
            <h2>{"imageSMOL"}{image.title.to_owned()}</h2>
        </div>
    }
}

#[derive(Clone, Deserialize, Eq, Properties, PartialEq)]
pub struct Model {
    pub title: String,
}

pub enum Msg {
}

impl Component for Model {
    type Message = Msg;
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Self {
            title: "".to_owned(),
        }
    }

    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        false
    }

    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div class={css!("background-color: green;")}>
                <p>{ self.title.to_owned() }</p>
            </div>
        }
    }
}
