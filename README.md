EWF JS WIDGET TEMPLATE PROJECT
=================


Getting Started
- Clone template project `git@github.com:ynh/ewf-js-custom-widget.git`
- Clone ewf repository `git@github.com:ynh/EWF.git` and checkout the widget branch
- Link ewf folder `ln -s PATH_TO_EWF_REPOSITORY $ISE_EIFFEL/contrib/library/ewf-dev`


How to create a custom JS-WIDGET

#Introduction
The main goal of this module is to provide easy to use javascript/html widget (controls), which allow the developer to build dynamic interfaces without the need to code javascript code. The wsf_js_widget module creates the illusion of a shared state between client and server, this illusion is created by restoring the clients state in the beginning of each request.

The wsf_js_widget module provides so called "statefull" controls which can be modified on callback (when a callback event is triggered e.g the client presses a button). The callbacks can be fully defined in Eiffel using agents.

#Goal
The goal of this tutorial is to build a custom js widget control. We will build a simple bar chart which can be modified by the server. The javascript implementation is based on the javascript library d3. http://bl.ocks.org/mbostock/3885705

# Step 1
First we define the state which is shared between the client and the server. The bar chart data can be represented as a key value hashmap, but since the json standard does guarantee the key order, we will use a JSON list  containing objects with the key and the value.

[{"key":"Eiffel", "value":12}, {"key":"C#", "value":12}, {"key":"Java", "value":12}]


#Step 2
Based on the shared state we now can start the Eiffel implementation of the control.

## Basic WSF Control structure

	class
		WSF_BARCHART_CONTROL

	inherit

		WSF_CONTROL
			rename
				make as make_control
			end

	create
		make

	feature {NONE} -- Initialization

		make
			do
				make_control ("div")
			end

	feature -- State handling

		set_state (new_state: JSON_OBJECT)
			do		
			end

		state: WSF_JSON_OBJECT
			do
				create Result.make
			end

	feature -- Callback

		handle_callback (cname: LIST [STRING_32]; event: STRING_32; event_parameter: detachable ANY)
			do
					-- Do nothing here
			end

	feature -- Rendering

		render: STRING_32
			local
				temp: STRING_32
			do
				Result := render_tag ("Loading ...", "")
			end

	end

Now we can create the set data functions. This step is straight forward:
* We add the data structure to the class.

* Create a setter function which registers the change in the state_changes json object. This object is used to pass the state changes which happen in a call back to the browser. 

* Since the list of tuples is not a primitiv data type we need a function which translates the data as a json object. 

### Code changes

		feature -- Data

			set_data (a_data: like data)
				do
					data := a_data
					state_changes.replace (data_as_json, "data")
				end
	
			data_as_json : JSON_ARRAY
			local
				item: WSF_JSON_OBJECT
			do
				create Result.make_array
				across
					data as el
				loop
					create item.make
					if attached {STRING_32}el.item.at(0) as key and attached {DOUBLE}el.item.at(1) as value then
					item.put_string (key, "key")
					item.put_real (value, "value")
					Result.add(item)
					end
				end
			end
	
			data: ARRAY [TUPLE [STRING_8, DOUBLE]]

The state handling is still missing. We need to restore the state since the objects are recreated on each callback. 


		feature -- State handling

			set_state (new_state: JSON_OBJECT)
					-- Restore data from json
				do
					if attached {JSON_ARRAY} new_state.item ("data") as new_data then
						create data.make_empty
						across
							new_data.array_representation as d
						loop
							if attached {JSON_OBJECT} d.item as citem
								and then attached {JSON_STRING} citem.item ("key") as key
								and then attached {JSON_NUMBER} citem.item ("value") as value then
								data.put ([key.item,value.item.to_real_64],d.cursor_index)
							end
						end
					end
				end

			state: WSF_JSON_OBJECT
					-- Return state with data
				do
					create Result.make
					Result.put (data_as_json, "data")
				end

