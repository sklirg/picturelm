module Gallery.Utils exposing (getTriplet)

-- Rewrite to binary search?


getTriplet : a -> List a -> List a
getTriplet target items =
    case items of
        [] ->
            []

        [ a, b, c ] ->
            if List.member target [ a, b, c ] then
                [ a, b, c ]

            else
                []

        -- []
        _ :: _ ->
            let
                k =
                    case List.take 3 items of
                        [ x, y, z ] ->
                            if List.member target [ x, y, z ] then
                                if z == target then
                                    getTriplet target (List.drop 1 items)

                                else
                                    [ x, y, z ]

                            else
                                getTriplet target (List.drop 1 items)

                        [] ->
                            []

                        _ :: _ ->
                            []
            in
            k
