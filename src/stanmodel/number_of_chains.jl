function get_n_chains(model::CmdStanOptimizeModel)
  model.n_chains[1]
end

function set_n_chains(model::CmdStanOptimizeModel, n_chains)
  model.n_chains[1] = n_chains
end