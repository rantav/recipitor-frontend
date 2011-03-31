# To run this:
# $ heroku console.
# >> Paste this long line
# condensed in one line for heroku's console; yuk
g = JSON.parse(IO.read('NotableGroceryStores.json')); g['map'].each { |k,v|;  puts k; r = Net::HTTP.get 'api.duckduckgo.com', "/?q=#{URI.escape(k)}&o=json"; j = JSON.parse(r); url = nil; url =  j['Results'][0]['FirstURL'] if  j and j['Results'] and j['Results'][0]; StoreChain.create(:name => k, :url => url) and puts url}


