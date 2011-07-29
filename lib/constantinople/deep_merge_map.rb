module Constantinople
  module DeepMergeMap
    # deep_merge! will merge and overwrite any unmergeables in destination hash
    def deeper_merge!(source, options = {})
      default_opts = {:preserve_unmergeables => false}
      ::DeepMerge::deep_merge!(source, self, default_opts.merge(options))
    end
  end
end

class Map
  include ::Constantinople::DeepMergeMap
end