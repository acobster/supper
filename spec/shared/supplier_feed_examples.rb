RSpec.shared_examples_for 'a SupplierFeed' do
  describe 'class methods' do
    describe '#build' do
      it 'returns an instance of the correct class' do
        expect( feed ).to be_a Supper::SupplierFeed
        expect( feed ).to be_a klass
      end
    end
  end

  describe '#copy_inventory_file' do
    it 'copies the file locally' do
      # control what the local file is called
      expect( Dir::Tmpname ).to receive( :make_tmpname ).once.
        with( 'tmp/', '' ).and_return( local_file )

      ftp = double('ftp')
      expect( ftp ).to receive( :connect ).once.with( ftp_host )
      expect( ftp ).to receive( :passive= ).once.with( true )
      expect( ftp ).to receive( :login ).once.with( ftp_user, ftp_password )
      expect( ftp ).to receive( :gettextfile ).once.with( remote_file, local_file )

      feed.copy_inventory_file ftp
    end
  end

  describe '#read' do
    it 'returns a hash' do
      expect( File ).to receive(:read).once.and_return( raw_inventory )

      supplier_inventory = feed.read
      expect( supplier_inventory ).to be_a Hash

      text_inventory_hash.each do |sku, quantity|
        expect( supplier_inventory[sku] ).to eq quantity
      end
    end
  end
end
