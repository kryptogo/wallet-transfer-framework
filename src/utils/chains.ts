export interface ChainConfig {
  name: string;
  nativeToken: string;
  supportedTokens: string[];
  estimateFee: () => Promise<number>;
  validateAddress: (address: string) => boolean;
}

export const chainConfigs: Record<string, ChainConfig> = {
  TRON: {
    name: 'TRON',
    nativeToken: 'TRX',
    supportedTokens: ['USDT', 'USDC', 'TRX'],
    estimateFee: async () => 0.2,
    validateAddress: (address) => address.startsWith('T')
  },
  Ethereum: {
    name: 'Ethereum',
    nativeToken: 'ETH',
    supportedTokens: ['USDT', 'USDC', 'ETH', 'DAI'],
    estimateFee: async () => 5.0,
    validateAddress: (address) => address.startsWith('0x')
  }
  // Add more chains as needed
}; 