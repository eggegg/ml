require 'matrix'

module ML
  module Learner
    # Implementation of Perceptron Learning Algorithm
    class PerceptronLearner
      # Initialize a perceptron learner
      #
      # @param [Integer] dim the number of dimension
      def initialize dim
        @dim = dim
        @w = Matrix.column_vector(Array.new(dim + 1, 0))
      end

      # Train with supervised data
      #
      # @param [Hash] data supervised input data (mapping from array to integer)
      def train! data
        @update = 0
        while true
          misclassified = false

          for dat, result in data
            aug_data = Matrix.column_vector(dat)

            if classify(aug_data) != result
              misclassified = true

              @w = @w + result * aug_data
              @update += 1
              break
            end
          end

          break unless misclassified
        end
      end

      # The final coefficient of the line
      #
      # @return [Array] [a,b,c] for ax+by+c=0
      def line
        @w.column(0).to_a
      end

      # The number for updates
      #
      # @return [Integer] update count
      def update_count
        @update
      end

      # Predict certain data
      #
      # @param [Array] data data in question
      # @return [Integer] prediction
      def predict data
        classify Matrix.column_vector(data + [1.0])  
      end

    private
      def classify data
        (@w.transpose * data)[0,0] <=> 0
      end
    end
  end
end
