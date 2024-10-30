{-# LANGUAGE TypeFamilies #-}
module Hydra.Ledger.Triton.Era where

import Cardano.Ledger.Crypto (Crypto)
import Cardano.Ledger.Conway (ConwayEra)
import Cardano.Ledger.Core (Era(PreviousEra, EraCrypto, ProtVerHigh, ProtVerLow, eraName))
import Data.Kind (Type)

type TritonEra :: (Type -> Type) -> Type -> Type
data TritonEra u c

instance Crypto c => Era (TritonEra ConwayEra c) where
  type PreviousEra (TritonEra ConwayEra c) = ConwayEra c
  type EraCrypto (TritonEra ConwayEra c) = c
  type ProtVerHigh (TritonEra ConwayEra c) = ProtVerHigh (ConwayEra c)
  type ProtVerLow (TritonEra ConwayEra c) = ProtVerLow (ConwayEra c)

  eraName = "Hydra Triton " <> eraName @(ConwayEra c)
