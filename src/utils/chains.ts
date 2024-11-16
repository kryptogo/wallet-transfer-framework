export interface ChainConfig {
  name: string;
  supportedTokens: string[];
  estimateFee: () => Promise<number>;
  validateAddress: (address: string) => boolean;
}

export const chainConfigs: Record<string, ChainConfig> = {
  Ethereum: {
    name: 'Ethereum',
    supportedTokens: ['USDT', 'USDC'],
    estimateFee: async () => 5.0,
    validateAddress: (address: string) => address.startsWith('0x')
  },
  Base: {
    name: 'Base',
    supportedTokens: ['USDC'],
    estimateFee: async () => 0.1,
    validateAddress: (address: string) => address.startsWith('0x')
  }
}; 