class DeleteObjectJob < ApplicationJob
  queue_as :low

  def perform(object, user = nil, ip = nil)
    if object.is_a?(Inbox)
      Rails.logger.info "DeleteObjectJob - Verificando se é instância Evolution: #{object.id}"
      if object.evolution_api_instance?
        Rails.logger.info "DeleteObjectJob - Excluindo instância Evolution: #{object.id}"
        object.delete_evolution_instance
      end
    end
    object.destroy!
    process_post_deletion_tasks(object, user, ip)
  end

  def process_post_deletion_tasks(object, user, ip); end
end

DeleteObjectJob.prepend_mod_with('DeleteObjectJob')
