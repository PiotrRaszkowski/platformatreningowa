import { useEffect, useState } from 'react';
import type { HealthResponse } from '../types/health';
import { getHealthStatus } from '../services/healthService';

export function useHealthStatus() {
  const [health, setHealth] = useState<HealthResponse | null>(null);

  useEffect(() => {
    getHealthStatus().then(setHealth);
  }, []);

  return health;
}
