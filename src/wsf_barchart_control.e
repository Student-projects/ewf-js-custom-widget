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
