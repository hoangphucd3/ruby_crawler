require 'thread'

module Crawler
  class Threads
    # @param size [Integer]
    attr_reader :size

    # @param queue [Queue]
    attr_reader :queue

    # @param threads [Array]
    attr_reader :threads

    # @param size [Integer]
    def initialize(size = nil)
      @size = size || ENV['THREADS'].to_i
      @size = 1 if @size <= 0

      @threads = []
      @queue = Queue.new
    end

    # @param args [Array]
    # @param block [Proc]
    def add(*args, &block)
      queue << [block, args]
    end

    # @return [Array<Thread>]
    def start
      set_up_thread_pool
      threads.each(&:join)
    end

    private

    # @return [void]
    def set_up_thread_pool
      puts "Spawning #{size} threads...".green
      1.upto(size).each do |i|
        @threads << spawn_thread(i)
      end
    end

    # @return [Thread]
    def spawn_thread(i)
      Thread.new do
        until @queue.empty? do
          block, args = @queue.pop(true) rescue nil
          block.call(*args) if block
        end
      end
    end
  end
end
