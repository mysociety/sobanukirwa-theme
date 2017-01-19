# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
  # Example adding an instance variable to the frontpage controller
  # GeneralController.class_eval do
  #   def mycontroller
  #     @say_something = "Greetings friend"
  #   end
  # end
  # Example adding a new action to an existing controller
  # HelpController.class_eval do
  #   def help_out
  #   end
  # end

  HelpController.class_eval do

    private

    # Backported fix from release/0.25.0.0 - prevents error when
    # params[:contact] is missing or empty
    # https://github.com/mysociety/alaveteli/commit/d62498d26fe3250665ba0751e680b0c843adf65f
    def catch_spam
      if request.post? && params[:contact]
        if !params[:contact][:comment].blank? || !params[:contact].key?(:comment)
          redirect_to frontpage_url
        end
      end
    end

  end
end
