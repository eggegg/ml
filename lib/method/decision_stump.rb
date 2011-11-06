module ML
  module Learner
    # Implementation of decision stump learning
    class DecisionStumpLearner
      # Initialize a decision stump learner
      #
      # @param [Integer] dim dimension
      def initialize dim
        @dim = dim
        @min_error = 1.0/0
        @error_vector = []
      end

      # Train with a supervised data
      #
      # @param [Hash] data supervised input data (mapping from array to integer)
      # @return [Hash] {error} error of the training data
      def train! data
        min_error, best_hypo = 1.0/0, nil

        for i in 0...@dim
          hypo, error = search data, i
          update_hypo hypo, error
          @error_vector[i] = error
        end

        {:error => min_error}
      end

      # Predict certain data
      #
      # @param [Array] data data in question
      # @return [Integer] prediction
      def predict data
        classify data, @best_hypo
      end

      # Error vector of each dimension
      #
      # @return [Array] the error vector
      def error_vector
        @error_vector
      end

    private
      # hypothesis vector
      # h_{s,i,t}(x) = s sign((x)_i - t)
      # [s, i, t]

      def classify data, hypo
        val = data[hypo[1]] - hypo[2]
        sign = (val > 0) ? 1 : -1
        hypo[0] * sign
      end

      def update_hypo hypo, error
        if @min_error > error
          @best_hypo = hypo
          error = @min_error
        end
      end

      def search data, dim
        pool = data.to_a.sort_by {|line| line[0][dim]}
        max_diff, index = 0, nil
        pcount, ncount = 0, 0

        pool.each_with_index do |dat, i|
          if dat[1] == 1
            pcount += 1
          else
            ncount += 1
          end

          if (pcount - ncount).abs > max_diff.abs
            max_diff = pcount - ncount
            index = i
          end
        end

        thres = if index == pool.size - 1
                  pool[-1][0][dim] + 1
                else
                  (pool[index][0][dim] + pool[index+1][0][dim]) / 2.0
                end
        hypo = if max_diff > 0
                 [-1, dim, thres]
               else
                 [1, dim, thres]
               end

        [hypo, classify_error(pool, hypo)]
      end

      def classify_error data, hypo
        error = 0
        for dat, result in data
          error += 1 unless classify(dat, hypo) == result
        end
        error
      end
    end
  end
end