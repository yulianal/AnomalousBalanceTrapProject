# AnomalousBalanceTrap 🚀  
**ETH Surge Trap — Drosera Trap by yulianal**

---

## 🎯 Objective

Создать ловушку для Drosera, которая:

- Отслеживает _рост_ ETH на адресе,
- Срабатывает только при существенном скачке: более **5 ETH** и **20%**,
- Вызывает внешний обработчик (`LogAlertReceiver`) с логом в случае резкого прироста.

---

## 🔎 Trap Logic: `AnomalousBalanceTrap.sol`

```solidity
address public constant target = 0xc7e..2a4c1;
uint256 public constant thresholdPercent = 20;
uint256 public constant minDiffWei = 5 ether;
```

Сравнивает два баланса:
- `previous` < `latest`?
- Разница больше `5 ETH` и 20%?

Если да — ловушка срабатывает.

---

## 📡 Response Contract: `LogAlertReceiver.sol`

```solidity
event AnomalyDetected(address indexed origin, string reason);
```

Принимает `bytes`, декодирует `(diff, percent)`, логгирует событие.

---

## 🚀 Deploy & Usage

1. Деплой ловушки и обработчика через Forge.
2. Укажи `logAnomaly(bytes)` как функцию ответа.
3. Drosera будет вызывать при срабатывании.
4. Можно подключить скрипт с уведомлением в Discord.

---

## 🧪 Test Case

- Баланс был 10 ETH.
- Стал 16 ETH.
- Δ = 6 ETH, +60% → ловушка сработает.
