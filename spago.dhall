{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies = [ "aff-promise", "console", "effect", "foreign", "foreign-generic", "foreign-object", "options", "psci-support", "record", "tuples", "web-file", "web-socket" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
