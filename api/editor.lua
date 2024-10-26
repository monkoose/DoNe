--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.9.4

  Editor scripting documentation
--]]

---@meta
---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.editor
editor = {}

---A string, SHA1 of Defold editor
editor.editor_sha1 = nil

---A string, SHA1 of Defold engine
editor.engine_sha1 = nil

---Editor platform id.
---A string, either:
---- "x86_64-win32"
---- "x86_64-macos"
---- "arm64-macos"
---- "x86_64-linux"
editor.platform = nil

---"bottom"
editor.ui.ALIGNMENT.BOTTOM = nil

---"bottom-left"
editor.ui.ALIGNMENT.BOTTOM_LEFT = nil

---"bottom-right"
editor.ui.ALIGNMENT.BOTTOM_RIGHT = nil

---"center"
editor.ui.ALIGNMENT.CENTER = nil

---"left"
editor.ui.ALIGNMENT.LEFT = nil

---"right"
editor.ui.ALIGNMENT.RIGHT = nil

---"top"
editor.ui.ALIGNMENT.TOP = nil

---"top-left"
editor.ui.ALIGNMENT.TOP_LEFT = nil

---"top-right"
editor.ui.ALIGNMENT.TOP_RIGHT = nil

---"error"
editor.ui.COLOR.ERROR = nil

---"hint"
editor.ui.COLOR.HINT = nil

---"override"
editor.ui.COLOR.OVERRIDE = nil

---"text"
editor.ui.COLOR.TEXT = nil

---"warning"
editor.ui.COLOR.WARNING = nil

---"dialog"
editor.ui.HEADING_STYLE.DIALOG = nil

---"form"
editor.ui.HEADING_STYLE.FORM = nil

---"h1"
editor.ui.HEADING_STYLE.H1 = nil

---"h2"
editor.ui.HEADING_STYLE.H2 = nil

---"h3"
editor.ui.HEADING_STYLE.H3 = nil

---"h4"
editor.ui.HEADING_STYLE.H4 = nil

---"h5"
editor.ui.HEADING_STYLE.H5 = nil

---"h6"
editor.ui.HEADING_STYLE.H6 = nil

---"clear"
editor.ui.ICON.CLEAR = nil

---"minus"
editor.ui.ICON.MINUS = nil

---"open-resource"
editor.ui.ICON.OPEN_RESOURCE = nil

---"plus"
editor.ui.ICON.PLUS = nil

---"error"
editor.ui.ISSUE_SEVERITY.ERROR = nil

---"warning"
editor.ui.ISSUE_SEVERITY.WARNING = nil

---"horizontal"
editor.ui.ORIENTATION.HORIZONTAL = nil

---"vertical"
editor.ui.ORIENTATION.VERTICAL = nil

---"large"
editor.ui.PADDING.LARGE = nil

---"medium"
editor.ui.PADDING.MEDIUM = nil

---"none"
editor.ui.PADDING.NONE = nil

---"small"
editor.ui.PADDING.SMALL = nil

---"large"
editor.ui.SPACING.LARGE = nil

---"medium"
editor.ui.SPACING.MEDIUM = nil

---"none"
editor.ui.SPACING.NONE = nil

---"small"
editor.ui.SPACING.SMALL = nil

---"center"
editor.ui.TEXT_ALIGNMENT.CENTER = nil

---"justify"
editor.ui.TEXT_ALIGNMENT.JUSTIFY = nil

---"left"
editor.ui.TEXT_ALIGNMENT.LEFT = nil

---"right"
editor.ui.TEXT_ALIGNMENT.RIGHT = nil

---A string, version name of Defold
editor.version = nil

---Run bob the builder program
---For the full documentation of the available commands and options, see the bob manual.
---@param options table|nil table of command line options for bob, without the leading dashes (--). You can use snake_case instead of kebab-case for option keys. Only long option names are supported (i.e. output, not o). Supported value types are strings, integers and booleans. If an option takes no arguments, use a boolean (i.e. true). If an option may be repeated, you can use an array of values.
---@param ...commands string|nil bob commands, e.g. "resolve" or "build"
function editor.bob(options, ...commands) end

---Check if you can get this property so editor.get() won't throw an error
---@param node string|userdata Either resource path (e.g. "/main/game.script"), or internal node id passed to the script by the editor
---@param property string Either "path", "text", or a property from the Outline view (hover the label to see its editor script name)
---@return boolean value 
function editor.can_get(node, property) end

---Check if "set" action with this property won't throw an error
---@param node string|userdata Either resource path (e.g. "/main/game.script"), or internal node id passed to the script by the editor
---@param property string Either "path", "text", or a property from the Outline view (hover the label to see its editor script name)
---@return boolean value 
function editor.can_set(node, property) end

---Create a directory if it does not exist, and all non-existent parent directories.
---Throws an error if the directory can't be created.
---@param resource_path string Resource path (starting with /) of a directory to create
function editor.create_directory(resource_path) end

---Delete a directory if it exists, and all existent child directories and files.
---Throws an error if the directory can't be deleted.
---@param resource_path string Resource path (starting with /) of a directory to delete
function editor.delete_directory(resource_path) end

---Execute a shell command.
---Any shell command arguments should be provided as separate argument strings to this function. If the exit code of the process is not zero, this function throws error. By default, the function returns nil, but it can be configured to capture the output of the shell command as string and return it — set out option to "capture" to do it.By default, after this shell command is executed, the editor will reload resources from disk.
---@param command string Shell command name to execute
---@param ... string|nil Optional shell command arguments
---@param options table|nil Optional options table. Supported entries:                                                                                                                                          boolean reload_resources: make the editor reload the resources from disk after the command is executed, default true                                                                                                                                            string out: standard output mode, either:                                                                                                                                                      "pipe": the output is piped to the editor console (this is the default behavior).                                                                                                                                                        "capture": capture and return the output to the editor script with trailing newlines trimmed.                                                                                                                                                        "discard": the output is discarded completely.                                                                                                                                                                                                                                              string err: standard error output mode, either:                                                                                                                                                      "pipe": the error output is piped to the editor console (this is the default behavior).                                                                                                                                                        "stdout": the error output is redirected to the standard output of the process.                                                                                                                                                        "discard": the error output is discarded completely.                                                                                                                                                                                            
---@return nil|string result If out option is set to "capture", returns the output as string with trimmed trailing newlines. Otherwise, returns nil.
function editor.execute(command, ..., options) end

---Query information about file system path
---@param path string External file path, resolved against project root if relative
---@return table attributes A table with the following keys:                                                  path string                                                  resolved file path                                                  exists boolean                                                  whether there is a file system entry at the path                                                  is_file boolean                                                  whether the path corresponds to a file                                                  is_directory boolean                                                  whether the path corresponds to a directory                                                
function editor.external_file_attributes(path) end

---Get a value of a node property inside the editor.
---Some properties might be read-only, and some might be unavailable in different contexts, so you should use editor.can_get() before reading them and editor.can_set() before making the editor set them.
---@param node string|userdata Either resource path (e.g. "/main/game.script"), or internal node id passed to the script by the editor
---@param property string Either "path", "text", or a property from the Outline view (hover the label to see its editor script name)
---@return any value property value
function editor.get(node, property) end

---Query information about a project resource
---@param resource_path string Resource path (starting with /) of a resource to look up
---@return table value A table with the following keys:exists booleanwhether a resource identified by the path exists in the projectis_file booleanwhether the resource represents a file with some contentis_directory booleanwhether the resource represents a directory
function editor.resource_attributes(resource_path) end

---Persist any unsaved changes to disk
function editor.save() end

---Change the editor state in a single, undoable transaction
---@param txs transaction_step[ ] An array of transaction steps created using editor.tx.* functions
function editor.transact(txs) end

---Create a set transaction step.
---When the step is transacted using editor.transact(), it will set the node's property to a supplied value
---@param node string|userdata Either resource path (e.g. "/main/game.script"), or internal node id passed to the script by the editor
---@param property string Either "path", "text", or a property from the Outline view (hover the label to see its editor script name)
---@param value any A new value for the property
---@return transaction_step result A transaction step
function editor.tx.set(node, property, value) end

---Button with a label and/or an icon
---@param props table Optional props: on_pressed functionbutton press callback, will be invoked without arguments when the user presses the buttontext stringthe texttext_alignment stringtext alignment within paragraph bounds; either: editor.ui.TEXT_ALIGNMENT.LEFTeditor.ui.TEXT_ALIGNMENT.CENTEReditor.ui.TEXT_ALIGNMENT.RIGHTeditor.ui.TEXT_ALIGNMENT.JUSTIFYicon stringpredefined icon name; either: editor.ui.ICON.OPEN_RESOURCEeditor.ui.ICON.PLUSeditor.ui.ICON.MINUSeditor.ui.ICON.CLEARenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.button(props) end

---Check box with a label
---@param props table Optional props: value booleandetermines if the checkbox should appear checkedon_value_changed functionchange callback, will receive the new valuetext stringthe texttext_alignment stringtext alignment within paragraph bounds; either: editor.ui.TEXT_ALIGNMENT.LEFTeditor.ui.TEXT_ALIGNMENT.CENTEReditor.ui.TEXT_ALIGNMENT.RIGHTeditor.ui.TEXT_ALIGNMENT.JUSTIFYissue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.check_box(props) end

---Convert a function to a UI component.
---The wrapped function may call any hooks functions (editor.ui.use_*), but on any function invocation, the hooks calls must be the same, and in the same order. This means that hooks should not be used inside loops and conditions or after a conditional return statement.
---The following props are supported automatically:grow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@param fn function function, will receive a single table of props when called
---@return function value decorated component function that may be invoked with a props table create component
function editor.ui.component(fn) end

---Dialog component, a top-level window component that can't be used as a child of other components
---@param props table Required props: title stringOS dialog window title  Optional props: header componenttop part of the dialog, defaults to editor.ui.heading({text = props.title})content componentcontent of the dialogbuttons component[]array of editor.ui.dialog_button(...) components, footer of the dialog. Defaults to a single Close button
---@return component value UI component
function editor.ui.dialog(props) end

---Dialog button shown in the footer of a dialog
---@param props table Required props: text stringbutton text  Optional props: result anyvalue returned by editor.ui.show_dialog(...) if this button is presseddefault booleanif set, pressing Enter in the dialog will trigger this buttoncancel booleanif set, pressing Escape in the dialog will trigger this buttonenabled booleandetermines if the button can be interacted with
---@return component value UI component
function editor.ui.dialog_button(props) end

---Input component for selecting files from the file system
---@param props table Optional props: value stringfile or directory path; resolved against project root if relativeon_value_changed functionvalue change callback, will receive the absolute path of a selected file/folder or nil if the field was cleared; even though the selector dialog allows selecting only files, it's possible to receive directories and non-existent file system entries using text field inputtitle stringOS window titlefilters table[]File filters, an array of filter tables, where each filter has following keys:description stringstring explaining the filter, e.g. "Text files (.txt)"extensions string[]array of file extension patterns, e.g. ".txt", "." or "game.project"issue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.external_file_field(props) end

---Layout container that places its children in a 2D grid
---@param props table Optional props: children component[][]array of arrays of child componentsrows table[]array of row option tables, separate configuration for each row:grow booleandetermines if the row should grow to fill available spacecolumns table[]array of column option tables, separate configuration for each column:grow booleandetermines if the column should grow to fill available spacepadding string, numberempty space from the edges of the container to its children; either: editor.ui.PADDING.NONEeditor.ui.PADDING.SMALLeditor.ui.PADDING.MEDIUMeditor.ui.PADDING.LARGEnon-negative number, pixelsspacing string, numberempty space between child components, defaults to editor.ui.SPACING.MEDIUM; either: editor.ui.SPACING.NONEeditor.ui.SPACING.SMALLeditor.ui.SPACING.MEDIUMeditor.ui.SPACING.LARGEnon-negative number, pixelsalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.grid(props) end

---A text heading
---@param props table Optional props: text stringthe texttext_alignment stringtext alignment within paragraph bounds; either: editor.ui.TEXT_ALIGNMENT.LEFTeditor.ui.TEXT_ALIGNMENT.CENTEReditor.ui.TEXT_ALIGNMENT.RIGHTeditor.ui.TEXT_ALIGNMENT.JUSTIFYcolor stringsemantic color, defaults to editor.ui.COLOR.TEXT; either: editor.ui.COLOR.TEXTeditor.ui.COLOR.HINTeditor.ui.COLOR.OVERRIDEeditor.ui.COLOR.WARNINGeditor.ui.COLOR.ERRORword_wrap booleandetermines if the lines of text are word-wrapped when they don't fit in the assigned bounds, defaults to truestyle stringheading style, defaults to editor.ui.HEADING_STYLE.H3; either: editor.ui.HEADING_STYLE.H1editor.ui.HEADING_STYLE.H2editor.ui.HEADING_STYLE.H3editor.ui.HEADING_STYLE.H4editor.ui.HEADING_STYLE.H5editor.ui.HEADING_STYLE.H6editor.ui.HEADING_STYLE.DIALOGeditor.ui.HEADING_STYLE.FORMalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.heading(props) end

---Layout container that places its children in a horizontal row one after another
---@param props table Optional props: children component[]array of child componentspadding string, numberempty space from the edges of the container to its children; either: editor.ui.PADDING.NONEeditor.ui.PADDING.SMALLeditor.ui.PADDING.MEDIUMeditor.ui.PADDING.LARGEnon-negative number, pixelsspacing string, numberempty space between child components, defaults to editor.ui.SPACING.MEDIUM; either: editor.ui.SPACING.NONEeditor.ui.SPACING.SMALLeditor.ui.SPACING.MEDIUMeditor.ui.SPACING.LARGEnon-negative number, pixelsalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.horizontal(props) end

---An icon from a predefined set
---@param props table Required props: icon stringpredefined icon name; either: editor.ui.ICON.OPEN_RESOURCEeditor.ui.ICON.PLUSeditor.ui.ICON.MINUSeditor.ui.ICON.CLEAR  Optional props: alignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.icon(props) end

---Integer input component based on a text field, reports changes on commit (Enter or focus loss)
---@param props table Optional props: value anyvalueon_value_changed functionvalue change callback, will receive the new valueissue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.integer_field(props) end

---Label intended for use with input components
---@param props table Optional props: text stringthe texttext_alignment stringtext alignment within paragraph bounds; either: editor.ui.TEXT_ALIGNMENT.LEFTeditor.ui.TEXT_ALIGNMENT.CENTEReditor.ui.TEXT_ALIGNMENT.RIGHTeditor.ui.TEXT_ALIGNMENT.JUSTIFYcolor stringsemantic color, defaults to editor.ui.COLOR.TEXT; either: editor.ui.COLOR.TEXTeditor.ui.COLOR.HINTeditor.ui.COLOR.OVERRIDEeditor.ui.COLOR.WARNINGeditor.ui.COLOR.ERRORtooltip stringtooltip message, shown on hoveralignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.label(props) end

---Number input component based on a text field, reports changes on commit (Enter or focus loss)
---@param props table Optional props: value anyvalueon_value_changed functionvalue change callback, will receive the new valueissue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.number_field(props) end

---Open a resource, either in the editor or in a third-party app
---@param resource_path string Resource path (starting with /) of a resource to open
function editor.ui.open_resource(resource_path) end

---A paragraph of text
---@param props table Optional props: text stringthe texttext_alignment stringtext alignment within paragraph bounds; either: editor.ui.TEXT_ALIGNMENT.LEFTeditor.ui.TEXT_ALIGNMENT.CENTEReditor.ui.TEXT_ALIGNMENT.RIGHTeditor.ui.TEXT_ALIGNMENT.JUSTIFYcolor stringsemantic color, defaults to editor.ui.COLOR.TEXT; either: editor.ui.COLOR.TEXTeditor.ui.COLOR.HINTeditor.ui.COLOR.OVERRIDEeditor.ui.COLOR.WARNINGeditor.ui.COLOR.ERRORword_wrap booleandetermines if the lines of text are word-wrapped when they don't fit in the assigned bounds, defaults to truealignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.paragraph(props) end

---Input component for selecting project resources
---@param props table Optional props: value stringresource path (must start with /)on_value_changed functionvalue change callback, will receive either resource path of a selected resource or nil when the field is cleared; even though the resource selector dialog allows filtering on resource extensions, it's possible to receive resources with other extensions and non-existent resources using text field inputtitle stringdialog title, defaults to "Select Resource"extensions string[]if specified, restricts selectable resources in the dialog to specified file extensions; e.g. {"collection", "go"}issue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.resource_field(props) end

---Layout container that optionally shows scroll bars if child contents overflow the assigned bounds
---@param props table Required props: content componentcontent component  Optional props: grow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.scroll(props) end

---Dropdown select box with an array of options
---@param props table Optional props: value anyselected valueon_value_changed functionchange callback, will receive the selected valueoptions any[]array of selectable optionsto_string functionfunction that converts an item to a string, defaults to tostringissue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.select_box(props) end

---Thin line for visual content separation, by default horizontal and aligned to center
---@param props table Optional props: orientation stringseparator line orientation, editor.ui.ORIENTATION.VERTICAL or editor.ui.ORIENTATION.HORIZONTAL; either: editor.ui.ORIENTATION.VERTICALeditor.ui.ORIENTATION.HORIZONTALalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.separator(props) end

---Show a modal dialog and await a result
---@param dialog component a component that resolves to editor.ui.dialog(...)
---@return any value dialog result, the value used as a result prop in a editor.ui.dialog_button({...}) selected by the user, or nil if the dialog was closed and there was no cancel = true dialog button with result prop set
function editor.ui.show_dialog(dialog) end

---Show a modal OS directory selection dialog and await a result
---@param opts table|nil path stringinitial file or directory path used by the dialog; resolved against project root if relativetitle stringOS window title
---@return string|nil value either absolute directory path or nil if user canceled directory selection
function editor.ui.show_external_directory_dialog(opts) end

---Show a modal OS file selection dialog and await a result
---@param opts table|nil path stringinitial file or directory path used by the dialog; resolved against project root if relativetitle stringOS window titlefilters table[]File filters, an array of filter tables, where each filter has following keys:description stringstring explaining the filter, e.g. "Text files (*.txt)"extensions string[]array of file extension patterns, e.g. "*.txt", "*.*" or "game.project"
---@return string|nil value either absolute file path or nil if user canceled file selection
function editor.ui.show_external_file_dialog(opts) end

---Show a modal resource selection dialog and await a result
---@param opts table|nil extensions string[]if specified, restricts selectable resources in the dialog to specified file extensions; e.g. {"collection", "go"}selection stringeither "single" or "multiple", defaults to "single"title stringdialog title, defaults to "Select Resource"
---@return string|string[ value |nil] if user made no selection, returns nil. Otherwise, if selection mode is "single", returns selected resource path; otherwise returns a non-empty array of selected resource paths.
function editor.ui.show_resource_dialog(opts) end

---String input component based on a text field, reports changes on commit (Enter or focus loss)
---@param props table Optional props: value anyvalueon_value_changed functionvalue change callback, will receive the new valueissue tableissue related to the input; table with the following keys (all required):severity stringeither editor.ui.ISSUE_SEVERITY.WARNING or editor.ui.ISSUE_SEVERITY.ERRORmessage stringissue message, will be shown in a tooltiptooltip stringtooltip message, shown on hoverenabled booleandetermines if the input component can be interacted withalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.string_field(props) end

---A hook that caches the result of a computation between re-renders.
---See editor.ui.component for hooks caveats and rules. If any of the arguments to use_memo change during a component refresh (checked with ==), the value will be recomputed.
---@param compute function function that will be used to compute the cached value
---@param ... ...any|nil args to the computation function
---@return ...any values all returned values of the compute function
function editor.ui.use_memo(compute, ...) end

---A hook that adds local state to the component.
---See editor.ui.component for hooks caveats and rules. If any of the arguments to use_state change during a component refresh (checked with ==), the current state will be reset to the initial one.
---@param init any|function local state initializer, either initial data structure or function that produces the data structure
---@param ... ...any|nil used when init is a function, the args are passed to the initializer function
---@return any state current local state, starts with initial state, then may be changed using the returned set_state function
---@return function set_state function that changes the local state and causes the component to refresh. The function may be used in 2 ways:                                                    to set the state to some other data structure: pass the data structure as a value                           to replace the state using updater function: pass a function to set_state — it will be invoked with the current state, as well as with the rest of the arguments passed to set_state after the updater function. The state will be set to the value returned from the updater function                         
function editor.ui.use_state(init, ...) end

---Layout container that places its children in a vertical column one after another
---@param props table Optional props: children component[]array of child componentspadding string, numberempty space from the edges of the container to its children; either: editor.ui.PADDING.NONEeditor.ui.PADDING.SMALLeditor.ui.PADDING.MEDIUMeditor.ui.PADDING.LARGEnon-negative number, pixelsspacing string, numberempty space between child components, defaults to editor.ui.SPACING.MEDIUM; either: editor.ui.SPACING.NONEeditor.ui.SPACING.SMALLeditor.ui.SPACING.MEDIUMeditor.ui.SPACING.LARGEnon-negative number, pixelsalignment stringalignment of the component content within its assigned bounds, defaults to editor.ui.ALIGNMENT.TOP_LEFT; either: editor.ui.ALIGNMENT.TOP_LEFTeditor.ui.ALIGNMENT.TOPeditor.ui.ALIGNMENT.TOP_RIGHTeditor.ui.ALIGNMENT.LEFTeditor.ui.ALIGNMENT.CENTEReditor.ui.ALIGNMENT.RIGHTeditor.ui.ALIGNMENT.BOTTOM_LEFTeditor.ui.ALIGNMENT.BOTTOMeditor.ui.ALIGNMENT.BOTTOM_RIGHTgrow booleandetermines if the component should grow to fill available space in a horizontal or vertical layout containerrow_span integerhow many rows the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.column_span integerhow many columns the component spans inside a grid container, must be positive. This prop is only useful for components inside a grid container.
---@return component value UI component
function editor.ui.vertical(props) end

return editor