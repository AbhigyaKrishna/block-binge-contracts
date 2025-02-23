<div align="center">

# 🎬 BlockBinge - Decentralized Pay-Per-View Streaming Platform

![BlockBinge Banner](assets/banner.jpeg)

> *Watch what you want, pay for what you watch. A revolutionary Web3 streaming platform powered by Reactive Smart Contracts.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![React](https://img.shields.io/badge/React-18.2.0-61DAFB.svg)](https://reactjs.org/)
[![IPFS](https://img.shields.io/badge/IPFS-Storage-65C2CB.svg)](https://ipfs.io/)
[![Website](https://img.shields.io/badge/Website-Block%20Binge-4E46E5)](https://blockbinge.vercel.app/)

[View Demo](https://blockbinge.vercel.app/) | [Smart Contracts](https://github.com/AbhigyaKrishna/block-binge-contracts) | [Frontend Code](https://github.com/vaibhavkothari33/BlockBinge)

</div>

## 🞳 Features

- **💰 Pay-Per-View**: Only pay for the content you actually watch
- **⚡ Real-Time Payments**: Automated microtransactions using Reactive Smart Contracts
- **🎯 Fair Revenue**: Direct payments to content creators with minimal platform fees
- **🔒 Decentralized**: Content stored on IPFS/Arweave for censorship resistance
- **💸 Flexible Pricing**: Support for per-second and flat-rate pricing models

## 🏗️ Architecture
```mermaid
graph TD
A[User] -->|Watch Content| B[BlockBinge dApp]
B -->|Store Content| C[IPFS/Arweave]
B -->|Process Payments| D[Reactive Smart Contracts]
D -->|Pay Creator| E[Creator Wallet]
D -->|Platform Fee| F[Platform Wallet]
```

### Contracts Flow
```mermaid
flowchart TB
    subgraph Sepolia["Sepolia Network"]
        direction TB
        SP["StreamingPlatform.sol <br> (Origin Contract)"]
        PC["PaymentCallback.sol <br> (Destination Contract)"]
        
        SP --> F1["Add Content"]
        SP --> F2["Verify Paymnet"]
        SP --> F3["Bill Session"]
        F3 --> E1["Add Content"]
        F3 --> E2["Bill Content"]

        subgraph "Event Handlers"
            EH1["Add Content <br> Stores movie metadata <br> on blockchain"]
            EH2["Bill Content <br> Calculates total amount <br> based on watch duration"]
        end

        subgraph "Payment Functions"
        direction TB
        PF1["sendToWallet() <br> Keeps platform cut"]
        PF2["sendPayment() <br> Pays content owner"]
        PF3["createPendingPayment() <br> Sends total amount to user"]
        
    end
    
    end

    subgraph Kopli["Kopli Network"]
        direction TB
        RP["StreamingReactivePlatform.sol <br> (Reactive Contract)"]
        
        %% subgraph "Event Handlers"
        %%     EH1["Add Content <br> Stores movie metadata <br> on blockchain"]
        %%     EH2["Bill Content <br> Calculates total amount <br> based on watch duration"]
        %% end
    end

    %% subgraph "Payment Functions"
    %%     direction TB
    %%     PF1["sendToWallet() <br> Keeps platform cut"]
    %%     PF2["sendPayment() <br> Pays content owner"]
    %%     PF3["createPendingPayment() <br> Sends total amount to user"]
    %% end

    RP --> EH1
    RP --> EH2
    E1 --> EH1
    E2 --> EH2
    EH2 -->|"Payment Callbacks"| PF1
    EH2 -->|"Payment Callbacks"| PF2
    EH2 -->|"Payment Callbacks"| PF3
    
    PF1 --> PC
    PF2 --> PC
    PF3 --> PC

    classDef contract fill:#f9f,stroke:#333,stroke-width:2px,color:black
    classDef event fill:#ff9,stroke:#333,stroke-width:2px,color:black
    classDef handler fill:#9f9,stroke:#333,stroke-width:2px,color:black
    classDef payment fill:#99f,stroke:#333,stroke-width:2px,color:black
    
    class SP,PC,RP contract
    class F1,F2,F3,E1,E2 event
    class EH1,EH2 handler
    class PF1,PF2,PF3 payment
```

## Video Explaination
<video src="https://www.youtube.com/watch?v=z-3BeEYIO8I" width="640" height="360" controls></video>

## 🛠️ Tech Stack

- **Smart Contracts**: Solidity ^0.8.19
- **Blockchain**: Ethereum/Polygon
- **Storage**: IPFS/Arweave
- **Payment System**: Reactive Smart Contracts
- **Frontend**: React.js (coming soon)

## 📦 Installation

1. Clone the repository
    ```bash
    git clone https://github.com/AbhigyaKrishna/block-binge-contracts.git
    cd block-binge-contracts
    ```

2. Install dependencies
    ```bash
    forge install
    ```

3. Set up deployment script
    ```bash
    cp .deploy-example.sh .deploy.sh
    chmod +x .deploy.sh
    ```

4. Fill in the details in the deployment script

5. Run the deployment script
    ```bash
    ./deploy.sh
    ```

## 📊 Payment Flow

1. User starts watching content
2. RSC tracks viewing duration
3. Payments processed automatically
4. Revenue split between creator and platform
5. Daily payment settlement

## 🛡 Security

- Reentrancy protection
- Access control mechanisms
- Secure payment processing

## ♡ Contributing

We welcome contributions! Please check our [Contributing Guidelines](CONTRIBUTING.md).

## 📝 License

MIT License - see the [LICENSE](LICENSE) file for details

## 🤝 Contact

| Name | Role | GitHub | X | LinkedIn |
|------|------|--------|---------|----------|
| Abhigya Krishna | Blockchain developer | [@AbhigyaKrishna](https://github.com/AbhigyaKrishna) | [@AbhigyaKr1shna](https://x.com/AbhigyaKr1shna) | [Abhigya Krishna](https://www.linkedin.com/in/abhigya-krishna/) |
| Navya Rathore | Gen AI developer | [@NavyaRathore](https://github.com/NavyaRathore) | [@eliza_darcy_01](https://x.com/eliza_darcy_01) | [Navya Rathore](https://www.linkedin.com/in/navya-rathore/) |
| Vaibhav Kothari | Frontend Developer | [@vaibhavkotharii](https://github.com/vaibhavkothari33) | [@VaibhavKotharii](https://x.com/VaibhavKotharii) | [Vaibhav Kothari](https://www.linkedin.com/in/vaibhavkothari33/) |
| Shrijan Katiyar | Technical Writer | [@youtubee](https://github.com/youutubee) | - | [Shrijan Katiyar](https://www.linkedin.com/in/shrijan-katiyar-49b068286/) |



---

<p align="center">
  Built with ❤️ by Coffee < Code > Crew
</p>

