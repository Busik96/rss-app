# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EntryDecorator do
  let(:entry) { EntryDecorator.new(details.entries.first) }
  let(:feed) { create :feed, :invalid }
  let(:fake_response) { instance_double('fake_response', body: fake_body) }
  let(:fake_body) { File.read(Rails.root.join('spec', 'support', 'najnowsze.xml')) }
  let(:details) { feed.details }

  before do
    allow(HTTParty).to receive(:get).and_return(fake_response)
  end

  describe '#title' do
    it 'returns entry title' do
      expect(entry.title).to eq('Obrady w Sali Kolumnowej. Prokuratura chce postawić zarzut sędziemu Tulei')
    end
  end

  describe '#img' do
    it 'returns entry img' do
      expect(entry.img).to include("tvn24.pl/najnowsze/cdn-zdjecie-bq8pzi-prokuratura-chce-postawiczarzut-karny-sedzi")
    end
  end

  describe '#description' do
    it 'returns entry description' do
      expect(entry.description).to include('Prokuratura Krajowa chce')
    end
  end

  describe '#published' do
    it 'returns entry published' do
      expect(entry.published).to eq('2020-02-27 11:21:41 UTC')
    end
  end

  describe '#url' do
    it 'returns entry url' do
      expect(entry.url).to eq('https://tvn24.pl/polska/sedzia-igor-tuleya-prokuratura-chce-mu-postawic-zarzut-chodzi-o-jego-decyzjew-sprawie-sledztwa-dotyczacego-obrad-w-sali-kolumnowej-4291443?source=rss')
    end
  end
end
