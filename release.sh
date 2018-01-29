#!/bin/sh

#mix deps.get --only prod
#MIX_ENV=prod mix compile
#cd assets
#node node_modules/brunch/bin/brunch build --production
#cd ..
#mix phx.digest
#
#MIX_ENV=prod mix release --env=prod

git push gigalixir master -f
gigalixir migrate $APP_NAME
