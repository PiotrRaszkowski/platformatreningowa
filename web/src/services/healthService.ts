import type { HealthResponse } from '../types/health';

export async function getHealthStatus(): Promise<HealthResponse> {
  return {
    status: 'UP',
    service: 'platforma-treningowa-backend',
    version: '0.0.1-SNAPSHOT'
  };
}
