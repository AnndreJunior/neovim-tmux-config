return {
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      local logo = [[
                     .                                                          
                      .:=+.                          .-:.                       
                    .=*##.                            -**=:                     
                   :*%###=:                          ..+###=                    
                  :######-.                          .*#####+.                  
                  *####+.                              -###*#+                  
                 -####+                                 :###*#:                 
                 +###%:                                . +####=                 
                 +####-               .                . =#**#=                 
                 -#####:                                .*##*#-                 
                  +#*###-.   ..::---=======---::..     :*##*#*.                 
                  .*#***#*++**####################*++=+##****:                  
                   :#*#***##******************#***#####*****+                   
                   :+:+*********************************#*--+                   
                   :=  :**************************+++***-. :=                   
                   :=   +*****+************************:   :=                   
                   :=   +*++++*+***********+****++***++.   :-                   
                   :=   =*++++*****+++*+++++++**+*+++++.   .                    
                   :=   :++++++--++*++++++++++==+-=++++.                        
                   :-   .+++- -  =.:+++++++++. .-  .++=                         
                   .    .+++     =. :+++++++.       -+:                         
                        .===.    -  .=======        -=.                         
                        .-:=-       :=======.      :=:                          
                        .- :==:....:=========:...:-=-:                          
                        .-  .:--====-=----=--=----: ::                          
                        .:      .::.::-::-:::...    .:                          
                        .:       :.   :. :          .:                          
                         :       ..   :.            ..                          
                         .       ..   ..            ..                          
                                 ..   .             ..                          
                                 ..   .             ..                          
                                      .             ..                          
                                      .             .                           
]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        config = {
          header = vim.split(logo, "\n"),
          center = {},
          footer = function()
            local quotes = {
              "☕ Transformando café em código...",
              "🚀 Salve com frequência, comite sem medo.",
              "🐛 Não é um bug, é uma feature não documentada.",
              "🔥 Sem 'sudo', sem glória.",
              "󰅩 Que seus testes passem de primeira hoje!",
            }
            math.randomseed(os.time())
            return { quotes[math.random(#quotes)] }
          end,
        },
      }

      return opts
    end,
  },
}
