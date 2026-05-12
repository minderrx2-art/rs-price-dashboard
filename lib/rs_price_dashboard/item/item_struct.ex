defmodule RsPriceDashboard.ItemStruct do
  @enforce_keys [:item_id, :name, :icon, :members, :low_alch, :high_alch, :limit, :examine]
  defstruct [:item_id, :name, :icon, :members, :low_alch, :high_alch, :limit, :examine]

  @type t :: %__MODULE__{
    item_id:   integer(),
    name:      String.t(),
    icon:      String.t(),
    members:   boolean(),
    low_alch:  integer()  | nil,
    high_alch: integer()  | nil,
    limit:     integer()  | nil,
    examine:   String.t() | nil
  }
end
