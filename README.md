# Feature-based transfer learning for network security

**Accepted in Milcom '17 ( IEEE Military Communications Conference )**

Manuscript at: http://7xpvay.com1.z0.glb.clouddn.com/Feature-Based-Transfer-Learning-for-Network-Security.pdf

The project deals with the problem of detecting zero attacks with tranfering the knowlege from known attack. The repository contains the relevant code to recreate the results in the paper. The abstract is provided below. The code can be implemented in any related domain.

> *Abstract* — Abstract—New and unseen network attacks pose a great threat to the signature-based detection systems. Consequently, machine learning-based approaches are designed to detect attacks, which rely on features extracted from network data. The problem is caused by different distribution of features in the training and testing datasets, which affects the performance of the learned models. Moreover, generating labeled datasets is very timeconsuming and expensive, which undercuts the effectiveness of supervised learning approaches. In this paper, we propose using transfer learning to detect previously unseen attacks. The main idea is to learn the optimized representation to be invariant to the changes of attack behaviors from labeled training sets and non-labeled testing sets, which contain different types of attacks and feed the representation to a supervised classifier. To the best of our knowledge, this is the first effort to use a feature-based transfer learning technique to detect unseen variants of network attacks. Furthermore, this technique can be used with any common base classifier. We evaluated the technique on publicly available datasets, and the results demonstrate the effectiveness of transfer learning to detect new network attacks.


## Note
Please note, if you need to use the code for any kind of academy use or commecial use, please cite paper:
J. Zhao, S. Shetty and J. W. Pan, "Feature-based transfer learning for network security," MILCOM 2017 - 2017 IEEE Military Communications Conference (MILCOM), Baltimore, MD, 2017, pp. 17-22.
doi: 10.1109/MILCOM.2017.8170749 https://ieeexplore.ieee.org/document/8170749/

Reproducing Results: Refer to scripts in Matlab/. Details provided in the readme
