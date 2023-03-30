{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "console"
  , "contravariant"
  , "effect"
  , "either"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "newtype"
  , "options"
  , "prelude"
  , "record"
  , "strings"
  , "transformers"
  , "tuples"
  , "unsafe-coerce"
  , "web-events"
  , "web-file"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
