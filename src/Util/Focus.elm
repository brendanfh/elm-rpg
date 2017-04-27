module Util.Focus
    exposing
        ( Focus
        , create
        , get
        , set
        , update
        , (.>)
        )


type alias Focus b s =
    { get : b -> s
    , update : (s -> s) -> b -> b
    }


create : (b -> s) -> ((s -> s) -> b -> b) -> Focus b s
create get update =
    { get = get, update = update }


get : Focus b s -> b -> s
get { get } b =
    get b


set : Focus b s -> s -> b -> b
set { update } s b =
    update (always s) b


update : Focus b s -> (s -> s) -> b -> b
update { update } f b =
    update f b


(.>) : Focus b m -> Focus m s -> Focus b s
(.>) bigf smallf =
    let
        get b =
            smallf.get (bigf.get b)

        update f b =
            bigf.update (smallf.update f) b
    in
        { get = get, update = update }
