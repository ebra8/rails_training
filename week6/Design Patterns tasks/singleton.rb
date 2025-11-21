class AppConfig
  @instance_mutex = Mutex.new
  private_class_method :new
  def initialize
    @settings = { env: "production" }
  end

  def self.instence
    return @instence if @instence

    @instance_mutex.synchronize do
      instence ||= new
    end
    @instence
  end

  def [](key)
    @settings[key]
  end
end

c1 = AppConfig.instence
c2 = AppConfig.instence

puts c1.object_id == c2.object_id