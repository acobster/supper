RSpec.shared_context 'suppliers' do
  let(:suppliers) { [supplier_bob, supplier_jane] }
  let(:supplier_bob) { double('supplier_bob') }
  let(:supplier_jane) { double('supplier_jane') }
end
