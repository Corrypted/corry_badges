# corry-logging

Police Badge script open for editing! The badge script allows custom images for the photo and allows players to steal the badges and use them with the same information there.

Feel free to star the repository and check out my portfolio and discord @ Discord: https://discord.gg/H7MVAeejPt & Portfolio: https://corry.io 
For support inquires please create a post in the support-forum channel on discord or create an issue here on Github.


### Video Preview
https://youtu.be/CDylAPJje4A

## Dependencies
1. ox_lib - https://github.com/overextended/ox_lib
2. ox_inventory - https://github.com/overextended/ox_inventory

## Installation

1. Clone or download this resource.
2. Place it in the server's resource directory.
3. Add the resource to your server config, if needed.
4. Make sure all dependencies are installed.
5. Add the following code into your ox_inventory:
 - Insert the following code into `ox_invetory/data/items.lua`:
    ```lua
    ["policebadge"] = {
		label = 'Badge',
		weight = 100,
		stack = false,
		close = true,
		description = "A badge to show you are a cop.",
		client = {
			image = "lspd.png",
		}
	},
    ```
 - Insert the following code into `ox_inventory/modules/items/client.lua`:
    ```lua
    Item('policebadge', function(data, slot)
        ox_inventory:useItem(data, function(data)
            if data then
                exports.corry_badges:openBadge(data, data.slot)
            end
        end)
    end)
    ```
6. Insert all images from `corry_badges/client/src/image` into `ox_inventory/web/images`

## Credit
Credit to x99 for creating the base UI - I just created it for QB-Core and optimized it using ox_lib and inventory.