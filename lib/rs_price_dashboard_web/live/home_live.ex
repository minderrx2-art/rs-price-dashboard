defmodule RsPriceDashboardWeb.HomeLive do
  use RsPriceDashboardWeb, :live_view

  alias RsPriceDashboard.PriceEts
  alias RsPriceDashboard.ItemStore

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(RsPriceDashboard.PubSub, "prices")
    end

    prices = PriceEts.get_stored_item_prices() |> Map.values()
    items = ItemStore.Items.get_all_items() |> Map.new(fn i ->
      {i.item_id, %{i | icon: String.replace(i.icon, " ", "_")}}
    end)

    socket =
      socket
      |> stream(:prices, prices, dom_id: &"price-#{&1.item_id}")
      |> assign(:items, items)
    {:ok, socket}
  end

  @impl true
  def handle_info({:price_updated, price}, socket) do
    {:noreply, stream_insert(socket, :prices, price, dom_id: &"price-#{&1.item_id}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mb-6">
        <h1 class="text-2xl font-bold tracking-tight">RS Price Dashboard</h1>
        <p class="text-sm text-base-content/50 mt-1">Prices update live as changes are detected</p>
      </div>

      <div class="rounded-xl border border-base-300 overflow-hidden">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-base-300 bg-base-200 text-base-content/50 text-xs uppercase tracking-wider">
              <th class="px-4 py-3 text-left font-medium">ID</th>
              <th class="px-4 py-3 text-left font-medium">Name</th>
              <th class="px-4 py-3 text-right font-medium">High</th>
              <th class="px-4 py-3 text-right font-medium">Low</th>
              <th class="px-4 py-3 text-right font-medium">Margin</th>
            </tr>
          </thead>
          <tbody id="prices" phx-update="stream">
            <tr :for={{id, price} <- @streams.prices} id={id}
              phx-hook=".PriceFlash"
              class="border-b border-base-300/50 hover:bg-base-200/50">
              <td class="px-4 py-2.5 font-mono text-base-content/50 text-xs">{price.item_id}</td>
              <td class="px-4 py-2.5 text-sm">
                <% item = Map.get(@items, price.item_id) %>
                <div class="flex items-center gap-2">
                  <img :if={item} src={"https://oldschool.runescape.wiki/images/#{item.icon}"} class="size-6 shrink-0" />
                  <span>{if item, do: item.name, else: "Unknown"}</span>
                </div>
              </td>
              <td class="px-4 py-2.5 text-right font-medium text-success">{price.high || "—"}</td>
              <td class="px-4 py-2.5 text-right font-medium text-error">{price.low || "—"}</td>
              <td class="px-4 py-2.5 text-right font-medium">
                {if price.high && price.low, do: price.high - price.low, else: "—"}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <script :type={Phoenix.LiveView.ColocatedHook} name=".PriceFlash">
        export default {
          updated() {
            this.el.classList.remove("price-flash")
            void this.el.offsetWidth
            this.el.classList.add("price-flash")
          }
        }
      </script>
    </Layouts.app>
    """
  end
end
