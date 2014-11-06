class UndoController < InheritedResources::Base
  include Volksplaner::Undo::ControllerHelpers
  skip_authorization_check

  def update
    if @undo = load_undo
      authorize! :update, @undo

      if @undo.execute!
        flash[:notice] = @undo.flash_message
        if @undo.redirectable?
          redirect_to @undo.location
        end
        clear_undo
      end
    else
      redirect_to root_path
    end
  end

end
