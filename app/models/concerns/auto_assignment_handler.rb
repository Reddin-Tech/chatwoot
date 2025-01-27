module AutoAssignmentHandler
  extend ActiveSupport::Concern
  include Events::Types

  included do
    after_save :run_auto_assignment
  end

  private

  def run_auto_assignment
    # Desativado o comportamento anterior de atribuição automática
    return false
  end

  def should_run_auto_assignment?
    # Desativado o comportamento anterior de atribuição automática
    return false
  end
end
