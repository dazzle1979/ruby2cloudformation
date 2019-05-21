require './cmdparser.rb'

describe 'cmdparser' do
  it 'check defaults output #1' do
    options = CmdParser.parse([])
    expect(options[:instances]).to eql(1)
    expect(options[:instance_type]).to eql('t2.micro')
    expect(options[:allow_ssh_from]).to eql('0.0.0.0/0')
  end
  it 'check output #1' do
    options = CmdParser.parse(['--instances','2','--instance-type','t2.small','--allow-ssh-from','37.17.210.74'])
    expect(options[:instances]).to eql(2)
    expect(options[:instance_type]).to eql('t2.small')
    expect(options[:allow_ssh_from]).to eql('37.17.210.74/32')
  end
end