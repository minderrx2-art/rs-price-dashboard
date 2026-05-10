defmodule RsPriceDashboard.PriceStruct do
  @enforce_keys [:item_id, :high, :low, :high_time, :low_time]
  defstruct [:item_id, :high, :low, :high_time, :low_time]

  @type t :: %__MODULE__{
    item_id:   integer(),
    high:      integer() | nil,
    low:       integer() | nil,
    high_time: integer() | nil,
    low_time:  integer() | nil
  }
end
