# abort an exception on a thread 
Thread.abort_on_exception = true

# Add a key on the thread
Thread.current["application"] = "Sketchup"

module Squall
  class Squall::ProgressBar
    # Methods declaration
    attr_reader :max, :value, :thd
    
    # progres bars collector
    @@activeProgressBarCollector = []
    
    # true if a progress bar is showed
    @@processing = false
    
    # static Method
    def self.processing()
      return @@processing
    end
    
    # Constructor
    def initialize(max, title = "In progress", timeLeft = "left", waitingMessages = [])
      # init variables
      @max = max
      @value = 0
      @previousValue = nil
      @title = title
      @finish = false
      @beginTime = Time.now
      @thd = nil
      @waitingMessages = waitingMessages
      @busy = false
      
      # if waiting messages
      heightMore = 0
      if (@waitingMessages.length > 0)
        heightMore = 35
      end
      
      # init web dialog
      @dialog = UI::WebDialog.new(title, false)
      @dialog.min_height = 92 + heightMore
      @dialog.max_height = 92 + heightMore
      @dialog.min_width = 380
      @dialog.max_width = 380
      @dialog.set_file(Sketchup.find_support_file("progressBar.html", "/Plugins/ProgressBar/html"))
      
      # Kill thread if the progress bar is closed
      onCancel()
      
      # Center the window
      @dialog.add_action_callback("screen") {|dlg, params|
        screen = eval(params)
        screenWidth = screen[0]
        screenHeight = screen[1]
        @dialog.set_position(screenWidth/2 - @dialog.min_width/2, screenHeight/2 - @dialog.min_height/2)
      }
      
      # Thread launch
      @dialog.add_action_callback("timer") {
        @timer = UI.start_timer(0, false) {
          # Stop the timer
          UI.stop_timer(@timer)
          @timer = nil
          
          # Execute the thread on 0.25s
          @thd.join(0.25)
          
          # Restart the timer
          @dialog.execute_script("Squall.progressBar.timeoutOnTimer();")
        }
      }
    end
    
    # Show and process a treatment
    def process()
      # Launch the thread and stop it immediatelly
      @thd = Thread.new() {
        begin
          # Stop the thread
          Thread.stop()

          # Insert the user process
          yield
          
          # Set the finish values
          @value = @max
          @finish = true
          
          # Close the progress
          @dialog.close()
        rescue Exception => e
          p e.message
          @dialog.close()
        end
      }
      @thd.priority = -1
      
      # Add the origress bar into the collector
      @@activeProgressBarCollector.push(self)
      
      # Run the process management
      Squall::ProgressBar.processesManagement()
    end
    
    # Treatment on colse the progress bar
    def onCancel() 
      # On close the web dialog
      @dialog.set_on_close() {
        # If not finish
        if (!@finish)
          @thd.kill()
          yield if block_given?
        end
        
        # Stop the timer
        if (@timer)
          UI.stop_timer(@timer)
        end

        # Delete self on the collector
        @@activeProgressBarCollector.delete(self)
                
        # Run again this method for the another progress bar
        Squall::ProgressBar.processesManagement()
      }
    end
    
    # Progress the avancement of the progress bar
    def progress(i = 1)
      # Set the value
      @value += i
      if (@value >= @max)
        @value = @max-1
      end
      
      # Get text value of pourcentage
      pourcent = ((@value.to_f()/@max.to_f())*100)
      pourcent = pourcent.to_i()
      
      # update the progress bar text
      @dialog.execute_script("Squall.progressBar.actualize(#{pourcent})")
    end
    
    # Show the progress bar
    def show()
      # Run the thread
      @thd.run()
      
      # Show the dialog
      timer = UI.start_timer(0.1, false) {
        # Stop the timer
        UI.stop_timer(timer)
        
        # Show the dialog
        @dialog.show_modal() {
          # Show the waiting messages
          if (@waitingMessages.length > 0)
            arrayStr = "["
            virgule = false
            for message in @waitingMessages
              if (virgule)
                arrayStr += ","
              else
                virgule = true
              end
              
              arrayStr += "\"#{message}\""
            end
            arrayStr += "]"
            
            # Execute the javascript
            @dialog.execute_script("Squall.progressBar.waitingMessages(#{arrayStr})")
          end
        }
      }
    end
    
    # Return true if the dialog is visible
    def visible?()
      return @dialog.visible?()
    end
  
    private
    # Management of the processes
    def self.processesManagement()
      if (@@activeProgressBarCollector.length == 1)
        # Set the globale variable
        @@processing = true
        
        # Get the first dialog
        pb = @@activeProgressBarCollector.first
        
        # Show it
        pb.show()
      elsif (@@activeProgressBarCollector.length == 0)
        # Set the globale variable
        @@processing = false
        
        # Clean the useless threads
        for thread in Thread.list
          if ((thread["application"] != "Sketchup") && (thread != Thread.current))
            thread.kill()
          end
        end
      end
    end
  end
end