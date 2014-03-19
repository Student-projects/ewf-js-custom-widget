note
	description: "Summary description for {WSF_BARCHART_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			data := <<>>
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

feature -- Rendering

	render: STRING_32
		do
			Result := render_tag ("Loading ...", "")
		end

end
