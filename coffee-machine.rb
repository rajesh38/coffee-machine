class CoffeeMachine
  attr_accessor :total_items_quantity, :outlets,
                :beverage_log, :beverages,
                :items_running_low, :beverage_failure_reason

  # Initialize with properties for the coffee machine
  def initialize(outlets:, total_items_quantity:, beverages:)
    self.outlets = outlets
    self.total_items_quantity = total_items_quantity
    self.beverages = beverages
    self.beverage_log = []
    self.items_running_low = {}
    self.beverage_failure_reason = {}
  end

  # When an item gets consumed we have to reduce the used quantity
  def use_item(item_name:, quantity:)
    total_items_quantity[item_name] -= quantity
  end

  # Checking if all the items are available in the needed quantity
  # Also setting reason for not being able to make a beverage 
  # due to unavailability of some item or not in needed quantity
  def check_all_items_availability?(beverage_name:, items_needed_quantity:)
    all_items_available = true
    items_needed_quantity.each do |item_name, quantity|
      if !total_items_quantity.key?(item_name)
        all_items_available = false
        self.beverage_failure_reason[beverage_name] = "#{item_name} is not available"
      elsif quantity > total_items_quantity[item_name]
        # When an item is not available in the needed quantity
        # then we set the item as running low and should raise
        # a red flag in the coffee machine
        items_running_low[item_name] = true
        all_items_available = false
        self.beverage_failure_reason[beverage_name] = "#{item_name} is not sufficient"
      end
    end
    return all_items_available
  end

  # Use this method to refill an item in a certain quantity
  def refill(item_name:, quantity:)
    total_items_quantity[item_name] += quantity
    items_running_low[item_name] = false
  end

  # Method to log success for making a beverage
  def log_beverage_success(beverage_name:)
    self.beverage_log << "#{beverage_name} is prepared"
  end

  # Method to log failure for making a beverage with reason
  def log_beverage_failure(beverage_name:)
    self.beverage_log << "#{beverage_name} cannot be prepared because #{self.beverage_failure_reason[beverage_name]}"
  end

  # Method to make the list of beverages
  def make_beverages
    beverages.each do |beverage_name, items_needed_quantity|
      error_reason = nil
      # checking availability of all items to make a particular beverage
      if check_all_items_availability?(
        beverage_name: beverage_name,
        items_needed_quantity: items_needed_quantity
      )
        items_needed_quantity.each do |item_name, quantity|
          use_item(item_name: item_name, quantity: quantity)
        end
        log_beverage_success(beverage_name: beverage_name)
      # if at least one item doesn't meet the needed quantity
      # the else block will log failure message
      else
        log_beverage_failure(beverage_name: beverage_name)
      end
    end
    # printing the collected logs
    puts beverage_log
  end
end

def execute_coffee_machine(coffee_machine_config)
  machine_config = coffee_machine_config[:machine]
  coffee_machine = CoffeeMachine.new(
    outlets: machine_config[:outlets],
    total_items_quantity: machine_config[:total_items_quantity],
    beverages: machine_config[:beverages],
  )
  coffee_machine.make_beverages
end