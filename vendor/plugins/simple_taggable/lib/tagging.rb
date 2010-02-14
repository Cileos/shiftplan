class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  after_destroy :destroy_tag_if_unused

  protected

    def destroy_tag_if_unused
      tag.destroy if Tag.destroy_unused && tag.taggings.count.zero?
    end
end
