# Copyright (C) 2024 Rudson Alves
# 
# This file is part of bgbazzar.
# 
# bgbazzar is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# bgbazzar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with bgbazzar.  If not, see <https://www.gnu.org/licenses/>.

# docker_up:
# 	docker compose up -d

# docker_down:
# 	docker compose down

clean:
	flutter clean && flutter pub get

diff:
	git add .
	git diff --cached > ~/diff

push:
	git add .
	git commit -F ~/commit.txt
	git push origin HEAD
	git checkout main

build_profile:
	flutter clean
	flutter pub get
	flutter run --profile

firebase_emu:
	firebase emulators:start --import=./emulator_data

firebase_emu_debug:
	firebase emulators:start --import=./emulator_data --debug

firebase_emusavecache:
	firebase emulators:export ./emulator_data -f

firebase_functions_deploy:
	firebase deploy --only functions

build_runner:
	dart run build_runner watch
	
schedule_clound:
	curl -X POST http://192.168.0.22:5001/delivery-16712/southamerica-east1/checkReservedDeliveries-0