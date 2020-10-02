library(nomnoml)

nomnoml("[Machine Learning] -> [Supervised Learning]
        [Machine Learning] -> [Unsupervised Learning]
        
        [Unsupervised Learning -> [Contoh Supervised]
        [Contoh Supervised] -> [Regressi]
        [Contoh Supervised -> [K-Means Clustering]
        [Contoh Supervised -> [Lainnya]
        [Supervised Learning] -> [Decision Tree]
        [Supervised Learning] -> [Random Forest]
        ",
        "Penjelasan.png")
