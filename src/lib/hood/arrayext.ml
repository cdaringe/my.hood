let replace l pos a = Array.mapi (fun i x -> if i = pos then a else x) l
