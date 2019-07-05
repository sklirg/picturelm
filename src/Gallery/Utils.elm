module Gallery.Utils exposing (get5, get7, get9, getTriplet)

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

        _ :: _ ->
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


get5 : a -> List a -> List a
get5 target items =
    case items of
        [] ->
            []

        [ a, b, c, d, e ] ->
            if List.member target [ a, b, c, d, e ] then
                [ a, b, c, d, e ]

            else
                []

        _ :: _ ->
            case List.take 5 items of
                [ a, b, c, d, e ] ->
                    if List.member target [ a, b, c, d, e ] then
                        if d == target || e == target then
                            get5 target (List.drop 1 items)

                        else
                            [ a, b, c, d, e ]

                    else
                        get5 target (List.drop 1 items)

                [] ->
                    []

                _ :: _ ->
                    []


get7 : a -> List a -> List a
get7 target items =
    case items of
        [] ->
            []

        [ a, b, c, d, e, f, g ] ->
            if List.member target [ a, b, c, d, e, f, g ] then
                [ a, b, c, d, e, f, g ]

            else
                []

        _ :: _ ->
            case List.take 7 items of
                [ a, b, c, d, e, f, g ] ->
                    if List.member target [ a, b, c, d, e, f, g ] then
                        if g == target || f == target || e == target then
                            get7 target (List.drop 1 items)

                        else
                            [ a, b, c, d, e, f, g ]

                    else
                        get7 target (List.drop 1 items)

                [] ->
                    []

                _ :: _ ->
                    []


get9 : a -> List a -> List a
get9 target items =
    case items of
        [] ->
            []

        [ a, b, c, d, e, f, g, h, i ] ->
            if List.member target [ a, b, c, d, e, f, g, h, i ] then
                [ a, b, c, d, e, f, g, h, i ]

            else
                []

        _ :: _ ->
            case List.take 9 items of
                [ a, b, c, d, e, f, g, h, i ] ->
                    if List.member target [ a, b, c, d, e, f, g, h, i ] then
                        if i == target || h == target || g == target || f == target then
                            get9 target (List.drop 1 items)

                        else
                            [ a, b, c, d, e, f, g, h, i ]

                    else
                        get9 target (List.drop 1 items)

                [] ->
                    []

                _ :: _ ->
                    []


