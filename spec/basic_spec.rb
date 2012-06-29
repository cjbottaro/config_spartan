require "spec_helper"

describe ConfigSpartan do

  context ".create" do

    it "works with a single file" do
      config = ConfigSpartan.create{ file("spec/config1.yml") }
      config.host.should == "dev.something.com"
      config.urls.should == %w[www.google.com www.yahoo.com]
      config[:count].should == 11
    end

    it "merges multiple files" do
      config = ConfigSpartan.create do
        file "spec/config1.yml"
        file "spec/config2.yml"
      end

      config.host.should == "prod.something.com"
      config.urls.should == %w[www.bing.com www.cuil.com]
      config[:count].should == 11
      config.nest.something.should == "blah"
      config.nest.name.fname.should == "coco"
      config.nest.name.lname.should == "bottaro"
    end

  end

end
