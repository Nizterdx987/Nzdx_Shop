Config = {}

-- Config General
Config.Locale = 'id'
Config.Target = false  -- Jika Ingin Menggunakan Target Maka Ubah Menjadi true
Config.TextUi = true  -- Jika Menggunakan TextUI Maka Ubah Menjadi true

-- Config Regulasi Setiap Toko --
Config.RegulasiBaju   = 5000   -- Harga Setiap Membeli Pakaian
Config.RegulasiPotong = 5000 -- Harga Setiap Potong Rambut
Config.RegulasiOplas  = 75000 -- Harga Setiap Operasi Plastik


-- Config Setting Marker
Config.Marker         = false  -- Jika Ingin Menggunakan Marker Maka Ubah Menjadi true
Config.Jangkauan      = 3.0  -- Jarak Pengelihatan Player Dengan Marker
Config.UkuranMarker   = {x = 1.5, y = 1.5, z = 1.0} -- Besar Kecilnya Bentuk Dari Marker
Config.WarnaMarker    = {r = 102, g = 102, b = 204} -- Warna yang dihasilkan di Marker
Config.TypeMarker     = 27 -- Bentuk Yang dihasilkan di Marker

-- Config Posisi Setiap Toko --
--- Toko Baju ---
Config.Zones = {}
Config.TokoBaju = {
  {x=72.254,    y=-1399.102, z=28.38},
  {x=-703.776,  y=-152.258,  z=36.42},
  {x=-167.863,  y=-298.969,  z=38.74},
  {x=428.694,   y=-800.106,  z=28.50},
  {x=-829.413,  y=-1073.710, z=10.33},
  {x=-1447.797, y=-242.461,  z=48.83},
  {x=11.632,    y=6514.224,  z=30.88},
  {x=123.646,   y=-219.440,  z=53.56},
  {x=1696.291,  y=4829.312,  z=41.07},
  {x=618.093,   y=2759.629,  z=41.09},
  {x=1190.550,  y=2713.441,  z=37.23},
  {x=-1193.429, y=-772.262,  z=16.33},
  {x=-3172.496, y=1048.133,  z=19.87},
  {x=-1108.441, y=2708.923,  z=18.11},
}
Config.rahasia = {
  --{x= 123.00, y= 456.00, z= 789.00},
}

--- Pangkas Rambut ---
Config.ZonesPangkasRambut = {}
Config.PangkasRambut = {
	{x= -814.3,  y= -183.8,   z= 36.6},
	{x= 136.8,   y= -1708.4,  z= 28.3},
	{x= -1282.6, y= -1116.8,  z= 6.0},
	{x= 1931.5,  y=  3729.7,  z= 31.8},
	{x= 1212.8,  y=  -472.9,  z= 65.2},
	{x= -32.9,   y=  -152.3,  z= 56.1},
	{x= -278.1,  y=  6228.5,  z= 30.7},
}

--- Operasi Plastik ---
Config.ZonesOperasiPlastik = {}
Config.OperasiPlastik = {
  {x = 338.25, y = -575.8,  z = 43.28} ,
}



--- Config Notifikasi ---
--- Client ---
function sukses(msg)
  exports['bcs_hud']:SendAlert('Shop Menu',msg, 'success', 3000)
  --exports['mythic_notify']:SendAlert('success', msg)
end

function error(msg)
  exports['bcs_hud']:SendAlert('Shop Menu',msg, 'error', 3000)
  --exports['mythic_notify']:SendAlert('error', msg)
end

--- Server ---
function suksess(msg)
  TriggerClientEvent('hud:SendAlert', source, 'Shop Menu', msg, 'success', 3000, 'top-right')
  --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text =  msg })
end

function errors(msg)
  TriggerClientEvent('hud:SendAlert', source, 'Shop Menu', msg, 'error', 3000, 'bottom-right')
  --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text =  msg })
end
