class SelectBlockController < ApplicationController
    def select_block
        @block_count = 10 # To be fetched from the generator result
    end
end
