require 'users_collection'

describe UsersCollection do

  let(:data_string) { "Isaura:Amira,Elliot,Lizzie,Margarito,Verla,Wilford:Juggling\nElliot:Isaura,Madalyn,Margarito,Shakira:Juggling,Mineral collecting\nMadalyn:Amira,Elliot,Margarito,Verla:Driving,Mineral collecting,Rugby\nLizzie:Amira,Isaura,Verla:Driving,Mineral collecting,Rugby" }

  describe '#user_hash' do
    let(:data_string) { "Isaura:Amira,Verla,Wilford:Sleeping\nElliot:Isaura,Madalyn,Margarito,Shakira:Juggling,Mineral collecting\nMadalyn:Amira,Elliot,Verla:Planking,Mineral collecting,Rugby\nLizzie:Amira,Isaura,Verla:Driving,Eating,Rugby" }
    let(:user_hash) { {'Madalyn' => {friends: %w(Amira Elliot Verla), user_groups: ['Planking', 'Mineral collecting', 'Rugby']},
                       'Lizzie' => {friends: %w(Amira Isaura Verla), user_groups: ['Driving', 'Eating', 'Rugby']},
                       'Elliot' => {friends: %w(Isaura Madalyn Margarito Shakira), user_groups: ['Juggling', 'Mineral collecting']},
                       'Isaura' => {friends: %w(Amira Verla Wilford), user_groups: ['Sleeping']}} }

    let(:users_collection) { UsersCollection.new(data_string) }

    it { expect(users_collection.user_hash).to eq user_hash }
    it 'should return a hash of one user friends and interests' do
      expect(users_collection.user_hash[:friends]).to eq user_hash[:friends]
    end
    it 'should return user_groups' do
      expect(users_collection.user_hash[:user_groups]).to eq user_hash[:user_groups]
    end
  end

  context 'full data' do
    let(:users_collection_2) { UsersCollection.new(data_string_2) }
    let(:data_string_2) { "Amira:Isaura,Lizzie,Madalyn,Margarito,Shakira,Un:Driving,Mineral collecting\nElliot:Isaura,Madalyn,Margarito,Shakira:Juggling,Mineral collecting\nIsaura:Amira,Elliot,Lizzie,Margarito,Verla,Wilford:Juggling\nLizzie:Amira,Isaura,Verla:Driving,Mineral collecting,Rugby\nMadalyn:Amira,Elliot,Margarito,Verla:Driving,Mineral collecting,Rugby\nMargarito:Amira,Elliot,Isaura,Madalyn,Un,Verla:Mineral collecting\nShakira:Amira,Elliot,Verla,Wilford:Mineral collecting\nUn:Amira,Margarito,Wilford:\nVerla:Isaura,Lizzie,Madalyn,Margarito,Shakira:Driving,Juggling,Mineral collecting\nWilford:Isaura,Shakira,Un:Driving" }

    describe '#suggested_groups_for' do
      let(:suggestions) { ['Driving', 'Mineral collecting'] }

      it { expect(users_collection_2.suggested_groups_for("Isaura")).to match_array suggestions }
    end

    describe '#suggested_groups' do
      it { expect(users_collection_2.suggested_groups).to eq "Amira:Mineral collecting\nElliot:Mineral collecting\nIsaura:Driving,Mineral collecting\nLizzie:Driving,Juggling,Mineral collecting\nMadalyn:Driving,Juggling,Mineral collecting\nMargarito:Driving,Juggling,Mineral collecting\nShakira:Driving,Juggling,Mineral collecting\nUn:Driving,Mineral collecting\nVerla:Driving,Mineral collecting,Rugby\nWilford:Juggling,Mineral collecting\n" }
    end
  end
end
