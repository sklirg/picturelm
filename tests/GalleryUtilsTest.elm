module GalleryUtilsTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Gallery.Utils exposing (getTriplet)
import Test exposing (..)


suite : Test
suite =
    describe "Image view"
        [ describe "The image prev/next picker"
            [ test "Empty list returns empty list" <|
                \_ ->
                    let
                        emptyList =
                            []
                    in
                    Expect.equal emptyList (getTriplet "" [])
            , test "Three item list returns three items" <|
                \_ ->
                    let
                        expected =
                            [ "a", "b", "c" ]

                        list =
                            [ "a", "b", "c" ]
                    in
                    Expect.equal expected (getTriplet "a" list)
            , test "Four item list with target at start returns three items" <|
                \_ ->
                    let
                        expected =
                            [ "a", "b", "c" ]

                        list =
                            [ "a", "b", "c", "d" ]
                    in
                    Expect.equal expected (getTriplet "a" list)
            , test "Four item list with target at center of three first items returns three items" <|
                \_ ->
                    let
                        expected =
                            [ "a", "b", "c" ]

                        list =
                            [ "a", "b", "c", "d" ]
                    in
                    Expect.equal expected (getTriplet "b" list)
            , test "Four item list with target at end of three first items returns three last items" <|
                \_ ->
                    let
                        expected =
                            [ "b", "c", "d" ]

                        list =
                            [ "a", "b", "c", "d" ]
                    in
                    Expect.equal expected (getTriplet "c" list)
            , test "Four item list with target at end returns three items" <|
                \_ ->
                    let
                        expected =
                            [ "b", "c", "d" ]

                        list =
                            [ "a", "b", "c", "d" ]
                    in
                    Expect.equal expected (getTriplet "d" list)
            , test "100 item list with target near end returns three items" <|
                \_ ->
                    let
                        expected =
                            [ 97, 98, 99 ]

                        list =
                            List.range 1 100
                    in
                    Expect.equal expected (getTriplet 98 list)
            , test "100 item list with target next to end returns three last items" <|
                \_ ->
                    let
                        expected =
                            [ 98, 99, 100 ]

                        list =
                            List.range 1 100
                    in
                    Expect.equal expected (getTriplet 99 list)
            , test "100 item list with target at end returns three items" <|
                \_ ->
                    let
                        expected =
                            [ 98, 99, 100 ]

                        list =
                            List.range 1 100
                    in
                    Expect.equal expected (getTriplet 100 list)
            ]
        ]
