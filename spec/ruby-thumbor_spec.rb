require File.dirname(__FILE__) + '/spec_helper.rb'

image_url = 'my.domain.com/some/image/url.jpg'
image_md5 = 'f33af67e41168e80fcc5b00f8bd8061a'
key = 'my-security-key'

def decrypt_in_thumbor(str)
    result = system "python -c 'from thumbor.crypto import Crypto; cr = Crypto(\"my-security-key\"); print cr.decrypt(\"whatever\")"
    result.strip
end

describe Thumbor::CryptoURL, "#new" do

    it "should create a new instance passing key and keep it" do
        crypto = Thumbor::CryptoURL.new key
        crypto.key.should == 'my-security-keymy'
    end

end

describe Thumbor::CryptoURL, "#url_for" do
    it "should return just the image hash if no arguments passed" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url

        url.should == image_md5
    end

    it "should raise if no image passed" do
        crypto = Thumbor::CryptoURL.new key

        expect { crypto.url_for Hash.new }.to raise_error(RuntimeError)
    end

    it "should return proper url for width-only" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :width => 300

        url.should == '300x0/' << image_md5
    end

    it "should return proper url for height-only" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :height => 300

        url.should == '0x300/' << image_md5
    end

    it "should return proper url for width and height" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :width => 200, :height => 300

        url.should == '200x300/' << image_md5
    end

    it "should return proper smart url" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :width => 200, :height => 300, :smart => true

        url.should == '200x300/smart/' << image_md5
    end

    it "should return proper flip url if no width and height" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :flip => true

        url.should == '-0x0/' << image_md5
    end

    it "should return proper flop url if no width and height" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :flop => true

        url.should == '0x-0/' << image_md5
    end

    it "should return proper flip-flop url if no width and height" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :flip => true, :flop => true

        url.should == '-0x-0/' << image_md5
    end

    it "should return proper flip url if width" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :width => 300, :flip => true

        url.should == '-300x0/' << image_md5
    end

    it "should return proper flip url if width" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :height => 300, :flop => true

        url.should == '0x-300/' << image_md5
    end

    it "should return horizontal align" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :halign => 'left'

        url.should == 'left/' << image_md5
    end

    it "should not return horizontal align if it is center" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :halign => 'center'

        url.should == image_md5
    end

    it "should return vertical align" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :valign => 'top'

        url.should == 'top/' << image_md5
    end

    it "should not return vertical align if it is middle" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :valign => 'middle'

        url.should == image_md5
    end

    it "should return halign and valign properly" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :halign => 'left', :valign => 'top'

        url.should == 'left/top/' << image_md5
    end

    it "should return meta properly" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :meta => true

        url.should == 'meta/' << image_md5
    end

    it "should return proper crop url" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :crop => [10, 10, 30, 30]

        url.should == '10x10:30x30/' << image_md5
    end

    it "should ignore crop if all zeros" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.url_for :image => image_url, :crop => [0, 0, 0, 0]

        url.should == image_md5
    end

end

describe Thumbor::CryptoURL, "#generate" do

    it "should create a new instance passing key and keep it" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.generate :width => 300, :height => 200, :image => image_url

        url.should == '/qkLDiIbvtiks0Up9n5PACtmpOfX6dPXw4vP4kJU-jTfyF6y1GJBJyp7CHYh1H3R2/' << image_url
    end

    it "should allow thumbor to decrypt it properly" do
        crypto = Thumbor::CryptoURL.new key

        url = crypto.generate :width => 300, :height => 200, :image => image_url

        '/qkLDiIbvtiks0Up9n5PACtmpOfX6dPXw4vP4kJU-jTfyF6y1GJBJyp7CHYh1H3R2/' << image_url

    end

end