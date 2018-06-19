module Styles exposing (..)

import Css exposing (..)
import Css.Foreign as Foreign
import Css.Colors exposing (..)
import Html.Styled exposing (Html, Attribute)
import Html.Styled.Attributes exposing (..)


-- import Html.Styled.Attributes exposing (css, href, src)
-- test : Attribute msg


home : Html msg
home =
    Foreign.global
        [ Foreign.body [ backgroundColor (hex "#f0f8ff") ]
        , Foreign.h1 hOne
        , Foreign.h2 hTwo
        , Foreign.h3 hThree
        , Foreign.h4 hFour
        , Foreign.h5 hFive
        , Foreign.h6 hSix
        , Foreign.p [ margin3 zero zero (Css.rem 1.2) ]
        ]


container : Attribute msg
container =
    css
        [ marginLeft auto
        , marginRight auto
        , paddingRight (Css.rem 0.4)
        , paddingLeft (Css.rem 0.4)
        , displayFlex
        , flexDirection Css.column
        , Css.width (pct 80)
        ]


columns : Attribute msg
columns =
    css
        [ displayFlex
        , flexWrap Css.wrap
        , marginLeft (Css.rem -0.4)
        , marginRight (Css.rem -0.4)
        ]


column : Attribute msg
column =
    css
        [ flex (num 1)
        , maxWidth (pct 100)
        , paddingLeft (Css.rem 0.4)
        , paddingRight (Css.rem 0.4)
        ]


columnCol9 : Attribute msg
columnCol9 =
    css
        [ Css.width (pct 75)
        , flex none
        ]


navbar : Attribute msg
navbar =
    css
        [ alignItems stretch
        , displayFlex
        , flexWrap Css.wrap
        , justifyContent spaceBetween
        ]


navbarSection : Attribute msg
navbarSection =
    css
        [ alignItems center
        , displayFlex
        , flex3 (num 1) zero zero
        ]


btnLink : Attribute msg
btnLink =
    css
        [ -- background2 zero zero
          borderColor transparent
        , color (hex "#5755d9")
        ]


hs : Style
hs =
    Css.batch
        [ fontWeight (int 500)
        , lineHeight (num 1.2)
        , marginBottom (Css.rem 0.5)
        , marginTop zero
        ]


hOne : List Style
hOne =
    [ hs, fontSize (Css.rem 2) ]


hTwo : List Style
hTwo =
    [ hs, fontSize (Css.rem 1.6) ]


hThree : List Style
hThree =
    [ hs, fontSize (Css.rem 1.4) ]


hFour : List Style
hFour =
    [ hs, fontSize (Css.rem 1.2) ]


hFive : List Style
hFive =
    [ hs, fontSize (Css.rem 1) ]


hSix : List Style
hSix =
    [ hs, fontSize (Css.rem 0.8) ]


btn : Attribute msg
btn =
    css
        [ margin (px 12)
        , borderRadius (Css.rem 0.1)
        , Css.height (Css.rem 1.8)
        , fontSize (Css.rem 0.8)
        , cursor pointer
        , textAlign center
        , verticalAlign center
        , whiteSpace noWrap
        , Css.outline zero
        , padding2 (Css.rem 0.25) (Css.rem 0.4)
        ]
